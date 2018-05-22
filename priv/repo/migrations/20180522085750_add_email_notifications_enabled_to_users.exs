defmodule Haterblock.Repo.Migrations.AddEmailNotificationsEnabledToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:email_notifications_enabled, :boolean, default: true)
    end
  end
end
