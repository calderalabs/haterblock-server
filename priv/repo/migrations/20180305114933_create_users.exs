defmodule Haterblock.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:google_id, :string)
      add(:google_token, :string)
      add(:google_refresh_token, :string)
      add(:email, :string)
      add(:name, :string, null: false)

      timestamps()
    end

    create(index("users", [:google_id]))
  end
end
