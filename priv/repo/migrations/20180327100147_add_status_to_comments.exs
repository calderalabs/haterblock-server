defmodule Haterblock.Repo.Migrations.AddStatusToComments do
  use Ecto.Migration

  def change do
    alter table(:comments) do
      add(:status, :string, null: false)
    end
  end
end
