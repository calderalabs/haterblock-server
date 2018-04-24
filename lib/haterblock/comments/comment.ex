defmodule Haterblock.Comments.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias Haterblock.Comments.Comment

  @ranges %{
    positive: {5, 10},
    neutral: {-2, 4},
    negative: {-6, -3},
    hateful: {-10, -7}
  }

  schema "comments" do
    field(:body, :string)
    field(:google_id, :string)
    field(:score, :integer)
    field(:user_id, :integer)
    field(:status, :string)
    field(:published_at, :utc_datetime)
    field(:video_id, :string)

    timestamps()
  end

  @doc false
  def changeset(%Comment{} = comment, attrs) do
    comment
    |> cast(attrs, [:body, :google_id, :score, :status, :published_at, :user_id])
    |> validate_required([:body, :google_id, :score, :status, :published_at, :user_id])
  end

  def from_youtube_comment(youtube_comment) do
    {:ok, published_at, 0} = DateTime.from_iso8601(youtube_comment.snippet.publishedAt)

    %Comment{
      google_id: youtube_comment.id,
      body: youtube_comment.snippet.textDisplay,
      status: youtube_comment.snippet.moderationStatus || "published",
      published_at: published_at,
      video_id: youtube_comment.snippet.videoId
    }
  end

  def from_youtube_comments(youtube_comments) do
    youtube_comments |> Enum.map(&from_youtube_comment/1)
  end

  def sentiment_from_score(score) do
    {sentiment, _} =
      @ranges
      |> Enum.find(fn {_, range} ->
        score >= elem(range, 0) && score <= elem(range, 1)
      end)

    sentiment
  end

  def range_for_sentiments(sentiments) do
    sentiments
    |> Enum.map(fn sentiment ->
      @ranges |> Map.get(sentiment |> String.to_atom())
    end)
    |> Enum.reduce(fn {acc_min, acc_max}, {next_min, next_max} ->
      min =
        if next_min < acc_min do
          next_min
        else
          acc_min
        end

      max =
        if next_max > acc_max do
          next_max
        else
          acc_max
        end

      {min, max}
    end)
  end

  def filter_hateful_comments(comments) do
    comments
    |> Enum.filter(&(sentiment_from_score(&1.score) == :hateful))
  end
end
