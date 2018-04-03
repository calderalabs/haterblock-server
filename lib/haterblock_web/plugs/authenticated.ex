defmodule HaterblockWeb.Plugs.Authenticated do
  use HaterblockWeb, :controller
  alias Haterblock.Accounts

  def call(conn, _params) do
    authorization = conn |> get_req_header("authorization")

    case authorization do
      ["Bearer " <> token] ->
        verified_token = Haterblock.Auth.verify_token(token)

        case verified_token do
          %Joken.Token{error: nil, claims: %{"sub" => sub}} ->
            user = Accounts.get_user(sub)

            if user do
              conn |> assign(:current_user, user)
            else
              conn |> render_unauthorized
            end

          %Joken.Token{error: _error} ->
            conn |> render_unauthorized
        end

      _ ->
        conn |> render_unauthorized
    end
  end

  defp render_unauthorized(conn) do
    conn
    |> put_status(:unauthorized)
    |> render(HaterblockWeb.ErrorView, :"401")
    |> halt()
  end
end
