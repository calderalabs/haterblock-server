defmodule HaterblockWeb.AuthController do
  alias Haterblock.Accounts
  alias Haterblock.Accounts.User

  import Joken
  use HaterblockWeb, :controller
  plug Ueberauth
  action_fallback HaterblockWeb.FallbackController

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    with {:ok, %User{} = user} <- Accounts.find_or_create_by_google_id(auth.uid) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", user_path(conn, :show))
      |> json(%{token: generate_token(user.id).token})
    end
  end

  defp generate_token(id) do
    secret = Application.get_env(:haterblock, HaterblockWeb.Endpoint)[:secret_key_base]
    %{sub: id}
    |> token
    |> with_signer(hs256(secret))
    |> sign
  end
end
