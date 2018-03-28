defmodule Haterblock.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add(:body, :text, null: false)
      add(:google_id, :string)
      add(:score, :integer)
      add(:user_id, :integer, null: false)
      add(:status, :string, null: false)
      add(:published_at, :utc_datetime, null: false)

      timestamps()
    end

    create(index("comments", [:google_id]))
    create(index("comments", [:user_id]))
    create(index("comments", [:score]))
  end
end
