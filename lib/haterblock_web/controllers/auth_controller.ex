defmodule HaterblockWeb.AuthController do
  use HaterblockWeb, :controller
  plug Ueberauth

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    json conn, auth
  end
end
