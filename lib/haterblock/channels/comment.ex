defmodule Haterblock.Channels.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias Haterblock.Channels.Comment


  schema "comments" do
    field :body, :string
    field :google_id, :string

    timestamps()
  end

  @doc false
  def changeset(%Comment{} = comment, attrs) do
    comment
    |> cast(attrs, [:body, :google_id])
    |> validate_required([:body, :google_id])
  end
end
