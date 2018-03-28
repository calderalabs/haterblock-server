defmodule HaterblockWeb.AuthController do
  alias Haterblock.Accounts
  alias Haterblock.Accounts.User

  use HaterblockWeb, :controller
  plug(Ueberauth)
  action_fallback(HaterblockWeb.FallbackController)

  @allowed_names ["nemesys0", "eugeniodepalo", "MatchaLatteVlog"]

  plug(:authorize_name)

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    with {:ok, %User{} = user} <-
           Accounts.update_or_create_by_google_id(auth.uid, %{
             google_token: auth.credentials.token,
             google_refresh_token: auth.credentials.refresh_token,
             email: auth.info.email,
             name: auth.info.name
           }) do
      conn
      |> put_status(:ok)
      |> put_resp_header("location", user_path(conn, :show))
      |> json(%{token: Haterblock.Auth.generate_token(%{sub: user.id}).token})
    end
  end

  defp authorize_name(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    if !Enum.member?(@allowed_names, auth.info.name) do
      conn
      |> put_status(:unauthorized)
      |> render(HaterblockWeb.ErrorView, :"401")
      |> halt
    end
  end
end
