defmodule Haterblock.Comments.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias Haterblock.Comments.Comment

  schema "comments" do
    field(:body, :string)
    field(:google_id, :string)
    field(:score, :integer)
    field(:user_id, :integer)

    timestamps()
  end

  @doc false
  def changeset(%Comment{} = comment, attrs) do
    comment
    |> cast(attrs, [:body, :google_id, :score])
    |> validate_required([:body, :google_id, :score])
  end

  def from_youtube_comment(youtube_comment) do
    %Comment{
      google_id: youtube_comment.id,
      body: youtube_comment.snippet.textDisplay
    }
  end

  def from_youtube_comments(youtube_comments) do
    youtube_comments |> Enum.map(&from_youtube_comment/1)
  end
end
