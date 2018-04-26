defmodule HaterblockWeb.AuthControllerTest do
  use HaterblockWeb.ConnCase

  alias Haterblock.Accounts
  alias Haterblock.Accounts.User

  @ueberauth_auth %{
    uid: "1",
    info: %{name: "Ciccio Pasticcio", email: "test@example.com"},
    credentials: %{token: "123", refresh_token: "456"}
  }

  @user_attrs %{
    google_id: "1",
    google_token: "some google token",
    google_refresh_token: "some google refresh token",
    email: "test1@email.com",
    name: "Ciccio Pasticcio"
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "callback" do
    test "callback/2 returns a token and creates a new user", %{conn: conn} do
      response =
        HaterblockWeb.AuthController.callback(
          conn |> assign(:ueberauth_auth, @ueberauth_auth),
          %{}
        )
        |> json_response(200)

      created_user = User |> Ecto.Query.last() |> Haterblock.Repo.one()
      assert response["token"] == Haterblock.Auth.generate_token(%{sub: created_user.id}).token
    end

    test "callback/2 returns a token and finds existing user", %{conn: conn} do
      {:ok, user} = Accounts.create_user(@user_attrs)

      response =
        HaterblockWeb.AuthController.callback(
          conn |> assign(:ueberauth_auth, @ueberauth_auth),
          %{}
        )
        |> json_response(200)

      assert response["token"] == Haterblock.Auth.generate_token(%{sub: user.id}).token
    end

    test "callback/2 returns a token and updates exiting user", %{conn: conn} do
      {:ok, user} = Accounts.create_user(@user_attrs)

      HaterblockWeb.AuthController.callback(
        conn
        |> assign(:ueberauth_auth, %{
          uid: "1",
          credentials: %{token: "245", refresh_token: "123"},
          info: %{email: "test1@email.com", name: "Ciccio Pasticcio"}
        }),
        %{}
      )

      assert Accounts.get_user!(user.id).google_token == "245"
    end
  end
end
