defmodule Haterblock.Repo.Migrations.AddPublishedAtToComments do
  use Ecto.Migration

  def change do
    alter table(:comments) do
      add(:published_at, :utc_datetime)
    end
  end
end
