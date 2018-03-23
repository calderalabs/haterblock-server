defmodule Haterblock.Repo.Migrations.AddGoogleIdIndexToComments do
  use Ecto.Migration

  def change do
    create(index("comments", [:google_id]))
  end
end
