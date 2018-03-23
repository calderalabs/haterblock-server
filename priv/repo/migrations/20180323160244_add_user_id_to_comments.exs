defmodule Haterblock.Repo.Migrations.AddUserIdToComments do
  use Ecto.Migration

  def change do
    alter table(:comments) do
      add(:user_id, :integer)
    end

    create(index("comments", [:user_id]))
  end
end
