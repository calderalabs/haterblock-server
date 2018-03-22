defmodule Haterblock.Repo.Migrations.AddScoreToComments do
  use Ecto.Migration

  def change do
    alter table(:comments) do
      add(:score, :integer)
    end
  end
end
