defmodule HaterblockWeb.UserController do
  use HaterblockWeb, :controller

  alias Haterblock.Accounts
  alias Haterblock.Accounts.User

  action_fallback HaterblockWeb.FallbackController
  plug HaterblockWeb.Plugs.Authenticated

  def show(conn, _params) do
    render(conn, "show.json", user: conn.assigns.current_user)
  end
end
