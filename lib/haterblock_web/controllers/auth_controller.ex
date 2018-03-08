defmodule HaterblockWeb.AuthController do
  alias Haterblock.Accounts
  alias Haterblock.Accounts.User

  use HaterblockWeb, :controller
  plug(Ueberauth)
  action_fallback(HaterblockWeb.FallbackController)

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    with {:ok, %User{} = user} <- Accounts.find_or_create_by_google_id(auth.uid) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", user_path(conn, :show))
      |> json(%{token: Haterblock.Auth.generate_token(%{sub: user.id}).token})
    end
  end
end
