defmodule HaterblockWeb.AuthControllerTest do
  use HaterblockWeb.ConnCase
  alias Haterblock.Accounts
  alias Haterblock.Accounts.User

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "callback" do
    test "callback/2 returns a token and creates a new user", %{conn: conn} do
      response =
        HaterblockWeb.AuthController.callback(
          conn |> assign(:ueberauth_auth, %{uid: "1"}),
          %{}
        )
        |> json_response(200)

      created_user = User |> Ecto.Query.last() |> Haterblock.Repo.one()
      assert response["token"] == Haterblock.Auth.generate_token(%{sub: created_user.id}).token
    end

    test "callback/2 returns a token and finds existing user", %{conn: conn} do
      {:ok, user} = Accounts.create_user(%{google_id: "1"})

      response =
        HaterblockWeb.AuthController.callback(
          conn |> assign(:ueberauth_auth, %{uid: "1"}),
          %{}
        )
        |> json_response(200)

      assert response["token"] == Haterblock.Auth.generate_token(%{sub: user.id}).token
    end
  end
end
