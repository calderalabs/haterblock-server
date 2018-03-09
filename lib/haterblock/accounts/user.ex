defmodule Haterblock.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Haterblock.Accounts.User

  schema "users" do
    field(:google_id, :string)
    field(:google_token, :string)

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:google_id, :google_token])
    |> validate_required([:google_id, :google_token])
  end
end
