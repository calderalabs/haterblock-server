defmodule Haterblock.Channels.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias Haterblock.Channels.Comment

  schema "comments" do
    field(:body, :string)
    field(:google_id, :string)

    timestamps()
  end

  @doc false
  def changeset(%Comment{} = comment, attrs) do
    comment
    |> cast(attrs, [:body, :google_id])
    |> validate_required([:body, :google_id])
  end

  def from_youtube_comment(youtube_comment) do
    %Comment{
      google_id: youtube_comment.id,
      body: youtube_comment.snippet.textDisplay
    }
  end
end
