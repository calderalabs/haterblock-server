defmodule Haterblock.Repo.Migrations.AddVideoIdToComments do
  use Ecto.Migration

  def change do
    alter table(:comments) do
      add(:video_id, :string)
    end
  end
end
