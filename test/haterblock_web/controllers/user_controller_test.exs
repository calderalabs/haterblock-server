defmodule HaterblockWeb.UserControllerTest do
  use HaterblockWeb.ConnCase

  alias Haterblock.Accounts
  alias Haterblock.Accounts.User

  @create_attrs %{google_id: "some google id"}
  @invalid_attrs %{google_id: nil}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "show" do
    test "show user", %{conn: conn} do
      create_user()
      conn = get conn, user_path(conn, :show)
      assert json_response(conn, 200)["data"] ==  %{
        "id" => 1,
        "google_id" => "some google id"}
    end
  end

  defp create_user do
    user = fixture(:user)
    {:ok, user: user}
  end
end
