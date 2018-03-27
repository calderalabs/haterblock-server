defmodule Haterblock.Comments.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias Haterblock.Comments.Comment

  schema "comments" do
    field(:body, :string)
    field(:google_id, :string)
    field(:score, :integer)
    field(:user_id, :integer)
    field(:status, :string)

    timestamps()
  end

  @doc false
  def changeset(%Comment{} = comment, attrs) do
    comment
    |> cast(attrs, [:body, :google_id, :score, :status])
    |> validate_required([:body, :google_id, :score, :status])
  end

  def from_youtube_comment(youtube_comment) do
    %Comment{
      google_id: youtube_comment.id,
      body: youtube_comment.snippet.textDisplay,
      status: youtube_comment.snippet.moderationStatus || "published"
    }
  end

  def from_youtube_comments(youtube_comments) do
    youtube_comments |> Enum.map(&from_youtube_comment/1)
  end

  def sentiment_from_score(score) do
    case score do
      x when x in 5..10 -> "positive"
      x when x in -3..4 -> "neutral"
      x when x in -6..-4 -> "negative"
      x when x in -10..-7 -> "hateful"
      _ -> raise("Invalid Sentiment")
    end
  end

  def range_for_sentiment(sentiment) do
    case sentiment do
      "positive" -> {5, 10}
      "neutral" -> {-3, 4}
      "negative" -> {-6, -4}
      "hateful" -> {-10, -7}
    end
  end
end
