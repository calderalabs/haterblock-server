defmodule HaterblockWeb.Plugs.Authenticated do
  use HaterblockWeb, :controller
  alias Haterblock.Accounts

  def call(conn, _params) do
    [authorization] = conn |> get_req_header("authorization")

    case authorization do
      "Bearer " <> token ->
        verified_token = Haterblock.Auth.verify_token(token)

        case verified_token do
          %Joken.Token{error: nil, claims: %{"sub" => sub}} ->
            conn |> assign(:current_user, Accounts.get_user!(sub))

          %Joken.Token{error: error} ->
            conn
            |> put_status(:unauthorized)
            |> render(HaterblockWeb.ErrorView, :"401")
            |> halt()
        end

      _ ->
        conn
        |> put_status(:unauthorized)
        |> render(HaterblockWeb.ErrorView, :"401")
        |> halt()
    end
  end
end
