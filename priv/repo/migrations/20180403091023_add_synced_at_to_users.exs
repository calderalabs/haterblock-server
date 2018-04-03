defmodule Haterblock.Repo.Migrations.AddSyncedAtToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:synced_at, :utc_datetime)
      remove(:syncing)
    end
  end
end
