defmodule Haterblock.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Haterblock.Accounts.User

  schema "users" do
    field(:google_id, :string)
    field(:google_token, :string)
    field(:google_refresh_token, :string)
    field(:email, :string)
    field(:name, :string)
    field(:synced_at, :utc_datetime)
    field(:auto_reject_enabled, :boolean, default: false)

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [
      :google_id,
      :google_token,
      :google_refresh_token,
      :email,
      :name,
      :synced_at,
      :auto_reject_enabled
    ])
    |> validate_required([:google_id, :google_token, :google_refresh_token, :email, :name])
  end
end
