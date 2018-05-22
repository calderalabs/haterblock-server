defmodule HaterblockWeb.UserView do
  use HaterblockWeb, :view
  alias HaterblockWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      attributes: %{
        name: user.name,
        email: user.email,
        synced_at: user.synced_at,
        auto_reject_enabled: user.auto_reject_enabled,
        email_notifications_enabled: user.email_notifications_enabled
      }
    }
  end
end
