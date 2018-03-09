defmodule Haterblock.Repo.Migrations.AddGoogleTokenToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:google_token, :string)
    end
  end
end
