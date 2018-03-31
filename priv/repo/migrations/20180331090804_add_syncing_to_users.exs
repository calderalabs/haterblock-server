defmodule Haterblock.Repo.Migrations.AddSyncingToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:syncing, :boolean, default: false)
    end
  end
end
