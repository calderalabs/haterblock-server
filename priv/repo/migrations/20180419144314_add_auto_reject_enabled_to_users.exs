defmodule Haterblock.Repo.Migrations.AddAutoRejectEnabledToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:auto_reject_enabled, :boolean, default: false)
    end
  end
end
