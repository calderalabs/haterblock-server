defmodule Haterblock.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Haterblock.Accounts.User

  schema "users" do
    field(:google_id, :string)

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:google_id])
    |> validate_required([:google_id])
  end
end
