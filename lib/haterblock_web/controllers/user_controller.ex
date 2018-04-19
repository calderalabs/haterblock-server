defmodule HaterblockWeb.UserController do
  use HaterblockWeb, :controller

  action_fallback(HaterblockWeb.FallbackController)
  plug(HaterblockWeb.Plugs.Authenticated)

  def show(conn, _params) do
    render(conn, "show.json", user: conn.assigns.current_user)
  end

  def update(conn, %{"user" => user_params}) do
    user = conn.assigns.current_user

    with {:ok, %Haterblock.Accounts.User{} = user} <-
           Haterblock.Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end
end
