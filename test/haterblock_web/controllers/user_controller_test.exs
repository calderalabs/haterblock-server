defmodule HaterblockWeb.UserControllerTest do
  use HaterblockWeb.ConnCase

  alias Haterblock.Accounts

  @create_attrs %{google_id: "some google id", google_token: "some google token"}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "show" do
    test "show user", %{conn: conn} do
      {:ok, user: user} = create_user()
      token = Haterblock.Auth.generate_token(%{sub: user.id}).token

      response =
        conn
        |> put_req_header("authorization", "Bearer #{token}")
        |> get(user_path(conn, :show))
        |> json_response(200)

      assert response["data"] == %{"id" => user.id}
    end
  end

  defp create_user do
    user = fixture(:user)
    {:ok, user: user}
  end
end
