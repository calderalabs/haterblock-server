defmodule HaterblockWeb.AuthenticatedPlugTest do
  use HaterblockWeb.ConnCase

  alias Haterblock.Accounts

  setup %{conn: conn} do
    {:ok,
     conn:
       conn
       |> fetch_query_params
       |> Map.put(:params, %{"_format" => "json"})}
  end

  describe "call" do
    test "call/2 renders error with unauthorized with no authentication header", %{conn: conn} do
      response =
        HaterblockWeb.Plugs.Authenticated.call(conn, %{})
        |> json_response(401)

      assert response["error"] == "Unauthorized"
    end

    test "call/2 renders error with unauthorized with invalid token", %{conn: conn} do
      response =
        HaterblockWeb.Plugs.Authenticated.call(
          conn |> put_req_header("authorization", "Bearer 123"),
          %{}
        )
        |> json_response(401)

      assert response["error"] == "Unauthorized"
    end

    test "call/2 assigns the current user with valid token", %{conn: conn} do
      {:ok, user} = Accounts.create_user(%{google_id: "1", google_token: "123"})
      token = Haterblock.Auth.generate_token(%{sub: user.id}).token

      conn =
        HaterblockWeb.Plugs.Authenticated.call(
          conn |> put_req_header("authorization", "Bearer #{token}"),
          %{}
        )

      assert conn.assigns[:current_user] == user
    end
  end
end
