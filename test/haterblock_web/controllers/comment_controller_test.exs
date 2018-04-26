defmodule HaterblockWeb.CommentControllerTest do
  use HaterblockWeb.ConnCase

  alias Haterblock.Comments

  @create_attrs %{
    body: "some body",
    google_id: "some google_id",
    score: 0,
    status: "published",
    published_at: Timex.parse!("2015-06-24T04:50:34.0000000Z", "{ISO:Extended:Z}"),
    user_id: 1
  }

  def fixture(:comment) do
    {:ok, comment} = Comments.create_comment(@create_attrs)
    comment
  end

  setup %{conn: conn} do
    {:ok, user} =
      Haterblock.Accounts.create_user(%{
        google_id: "1",
        google_token: "1",
        google_refresh_token: "1",
        email: "email@example.com",
        name: "Test User"
      })

    {:ok,
     conn:
       conn
       |> put_req_header("accept", "application/json")
       |> put_req_header(
         "authorization",
         "Bearer #{Haterblock.Auth.generate_token(%{sub: user.id}).token}"
       )}
  end

  describe "index" do
    test "lists all comments", %{conn: conn} do
      conn = get(conn, comment_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end
end
