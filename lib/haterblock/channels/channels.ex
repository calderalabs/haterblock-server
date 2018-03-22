defmodule Haterblock.Channels do
  @moduledoc """
  The Channels context.
  """

  import Ecto.Query, warn: false
  alias Haterblock.Repo

  alias Haterblock.Channels.Comment

  @doc """
  Returns the list of comments.

  ## Examples

      iex> list_comments()
      [%Comment{}, ...]

  """
  def list_comments do
    Repo.all(Comment)
  end

  def list_youtube_videos(user) do
    conn = GoogleApi.YouTube.V3.Connection.new(user.google_token)

    {:ok, channels} =
      GoogleApi.YouTube.V3.Api.Channels.youtube_channels_list(conn, "contentDetails", [
        {:mine, true}
      ])

    items =
      channels.items
      |> Enum.at(0)

    uploadsPlaylist = items.contentDetails.relatedPlaylists.uploads

    {:ok, uploadedVideos} =
      GoogleApi.YouTube.V3.Api.PlaylistItems.youtube_playlist_items_list(conn, "contentDetails", [
        {:playlistId, uploadsPlaylist}
      ])

    uploadedVideos.items
    |> Enum.flat_map(fn item ->
      list_youtube_comments(user, item.contentDetails.videoId)
    end)
  end

  def list_youtube_comments(user, video_id) do
    conn = GoogleApi.YouTube.V3.Connection.new(user.google_token)

    {:ok, %{items: comment_threads}} =
      GoogleApi.YouTube.V3.Api.CommentThreads.youtube_comment_threads_list(
        conn,
        "id,snippet,replies",
        [
          {:videoId, video_id}
        ]
      )

    comment_threads
    |> Enum.flat_map(fn comment_thread ->
      replies =
        if comment_thread.replies != nil do
          comment_thread.replies.comments
        else
          []
        end

      [comment_thread.snippet.topLevelComment] ++ replies
    end)
    |> Enum.map(&Comment.from_youtube_comment/1)
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
end
