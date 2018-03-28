defmodule Haterblock.Comments.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias Haterblock.Comments.Comment

  @ranges %{
    positive: 5..10,
    neutral: -3..4,
    negative: -6..-4,
    hateful: -10..-7
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
    case score do
      x when x in unquote(Macro.escape(@ranges.positive)) -> "positive"
      x when x in unquote(Macro.escape(@ranges.neutral)) -> "neutral"
      x when x in unquote(Macro.escape(@ranges.negative)) -> "negative"
      x when x in unquote(Macro.escape(@ranges.hateful)) -> "hateful"
      _ -> raise("Invalid Sentiment")
    end
  end

  def range_for_sentiment(sentiment) do
    case sentiment do
      "positive" -> @ranges.positive
      "neutral" -> @ranges.neutral
      "negative" -> @ranges.negative
      "hateful" -> @ranges.hateful
    end
  end
end
