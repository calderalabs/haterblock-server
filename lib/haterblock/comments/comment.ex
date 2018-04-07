defmodule Haterblock.Comments.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias Haterblock.Comments.Comment

  @ranges %{
    positive: {5, 10},
    neutral: {-2, 4},
    negative: {-10, -3}
  }

  schema "comments" do
    field(:body, :string)
    field(:google_id, :string)
    field(:score, :integer)
    field(:user_id, :integer)
    field(:status, :string)
    field(:published_at, :utc_datetime)

    timestamps()
  end

  @doc false
  def changeset(%Comment{} = comment, attrs) do
    comment
    |> cast(attrs, [:body, :google_id, :score, :status, :published_at])
    |> validate_required([:body, :google_id, :score, :status, :published_at])
  end

  def from_youtube_comment(youtube_comment) do
    {:ok, published_at, 0} = DateTime.from_iso8601(youtube_comment.snippet.publishedAt)

    %Comment{
      google_id: youtube_comment.id,
      body: youtube_comment.snippet.textDisplay,
      status: youtube_comment.snippet.moderationStatus || "published",
      published_at: published_at
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
end
