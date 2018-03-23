defmodule HaterblockWeb.CommentControllerTest do
  use HaterblockWeb.ConnCase

  alias Haterblock.Comments
  alias Haterblock.Comments.Comment

  @create_attrs %{body: "some body", google_id: "some google_id", score: 0}
  @update_attrs %{body: "some updated body", google_id: "some updated google_id", score: 1}
  @invalid_attrs %{body: nil, google_id: nil, score: nil}

  def fixture(:comment) do
    {:ok, comment} = Comments.create_comment(@create_attrs)
    comment
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all comments", %{conn: conn} do
      conn = get(conn, comment_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "update comment" do
    setup [:create_comment]

    test "renders comment when data is valid", %{conn: conn, comment: %Comment{id: id} = comment} do
      conn = put(conn, comment_path(conn, :update, comment), comment: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, comment_path(conn, :show, id))

      assert json_response(conn, 200)["data"] == %{
               "id" => id,
               "body" => "some updated body",
               "google_id" => "some updated google_id",
               "score" => 1
             }
    end

    test "renders errors when data is invalid", %{conn: conn, comment: comment} do
      conn = put(conn, comment_path(conn, :update, comment), comment: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  defp create_comment(_) do
    comment = fixture(:comment)
    {:ok, comment: comment}
  end
end
