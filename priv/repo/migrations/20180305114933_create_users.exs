defmodule Haterblock.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :google_id, :string

      timestamps()
    end

  end
end
