defmodule Haterblock.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :body, :text
      add :google_id, :string

      timestamps()
    end

  end
end
