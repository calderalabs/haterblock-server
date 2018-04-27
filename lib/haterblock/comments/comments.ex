defmodule Haterblock.Comments do
  @moduledoc """
  The Comments context.
  """

  import Ecto.Query, warn: false
  alias Haterblock.Repo

  alias Haterblock.Comments.Comment

  @doc """
  Returns the list of comments.

  ## Examples

      iex> list_comments()
      [%Comment{}, ...]

  """
  def list_comments do
    from(c in base_query())
    |> Repo.all()
  end

  def list_comments(ids) do
    from(
      c in base_query(),
      where: c.id in ^ids
    )
    |> Repo.all()
  end

  def list_comments_for_user(
        user,
        %{page: page, statuses: statuses, sentiments: sentiments} \\ %{
          page: 1,
          statuses: ["published"],
          sentiments: ["hateful", "negative"]
        }
      ) do
    comments_for_user(user)
    |> comments_for_statuses(statuses)
    |> comments_for_sentiments(sentiments)
    |> Repo.paginate(page: page)
  end

  defp comments_for_statuses(query, statuses) do
    if Enum.empty?(statuses) do
      none_query(query)
    else
      from(
        c in query,
        where: c.status in ^statuses
      )
    end
  end

  defp comments_for_sentiments(query, sentiments) do
    if Enum.empty?(sentiments) do
      none_query(query)
    else
      {min, max} = Comment.range_for_sentiments(sentiments)

      from(
        c in query,
        where: c.score >= ^min and c.score <= ^max
      )
    end
  end

  defp base_query do
    from(
      c in Comment,
      order_by: [desc: c.published_at]
    )
  end

  defp none_query(query) do
    from(
      c in query,
      where: false == true
    )
  end

  defp comments_for_user(user) do
    from(
      c in base_query(),
      where: c.user_id == ^user.id
    )
  end

  def counts_for_user(user) do
    sentiments_counts =
      Enum.reduce(["hateful", "negative", "neutral", "positive"], %{}, fn sentiment, acc ->
        Map.put(
          acc,
          sentiment,
          comments_for_sentiments(comments_for_user(user), [sentiment])
          |> Repo.aggregate(:count, :id)
        )
      end)

    statuses_counts =
      Enum.reduce(["rejected", "published"], %{}, fn status, acc ->
        Map.put(
          acc,
          status,
          comments_for_statuses(comments_for_user(user), [status])
          |> Repo.aggregate(:count, :id)
        )
      end)

    %{
      hateful_comments: Map.get(sentiments_counts, "hateful"),
      negative_comments: Map.get(sentiments_counts, "negative"),
      neutral_comments: Map.get(sentiments_counts, "neutral"),
      positive_comments: Map.get(sentiments_counts, "positive"),
      rejected_comments: Map.get(statuses_counts, "rejected"),
      published_comments: Map.get(statuses_counts, "published")
    }
  end

  @doc """
  Gets a single comment.

  Raises `Ecto.NoResultsError` if the Comment does not exist.

  ## Examples

      iex> get_comment!(123)
      %Comment{}

      iex> get_comment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_comment!(id), do: Repo.get!(Comment, id)

  @doc """
  Creates a comment.

  ## Examples

      iex> create_comment(%{field: value})
      {:ok, %Comment{}}

      iex> create_comment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_comment(attrs \\ %{}) do
    %Comment{}
    |> Comment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a comment.

  ## Examples

      iex> update_comment(comment, %{field: new_value})
      {:ok, %Comment{}}

      iex> update_comment(comment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_comment(%Comment{} = comment, attrs) do
    comment
    |> Comment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Comment.

  ## Examples

      iex> delete_comment(comment)
      {:ok, %Comment{}}

      iex> delete_comment(comment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comment changes.

  ## Examples

      iex> change_comment(comment)
      %Ecto.Changeset{source: %Comment{}}

  """
  def change_comment(%Comment{} = comment) do
    Comment.changeset(comment, %{})
  end

  def reject_comments(comments, user) do
    {:ok} = Haterblock.Youtube.reject_comments(comments, user)

    updated_comments =
      comments
      |> Enum.map(fn comment ->
        {:ok, comment} = update_comment(comment, %{status: "rejected"})
        comment
      end)

    {:ok, updated_comments}
  end
end
