defmodule Haterblock.Repo.Migrations.AddGoogleRefreshTokenToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:google_refresh_token, :string)
    end
  end
end
