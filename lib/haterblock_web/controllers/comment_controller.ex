defmodule HaterblockWeb.CommentController do
  use HaterblockWeb, :controller

  alias Haterblock.Channels
  alias Haterblock.Channels.Comment

  action_fallback HaterblockWeb.FallbackController

  def index(conn, _params) do
    comments = Channels.list_comments()
    render(conn, "index.json", comments: comments)
  end

  def create(conn, %{"comment" => comment_params}) do
    with {:ok, %Comment{} = comment} <- Channels.create_comment(comment_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", comment_path(conn, :show, comment))
      |> render("show.json", comment: comment)
    end
  end

  def show(conn, %{"id" => id}) do
    comment = Channels.get_comment!(id)
    render(conn, "show.json", comment: comment)
  end

  def update(conn, %{"id" => id, "comment" => comment_params}) do
    comment = Channels.get_comment!(id)

    with {:ok, %Comment{} = comment} <- Channels.update_comment(comment, comment_params) do
      render(conn, "show.json", comment: comment)
    end
  end

  def delete(conn, %{"id" => id}) do
    comment = Channels.get_comment!(id)
    with {:ok, %Comment{}} <- Channels.delete_comment(comment) do
      send_resp(conn, :no_content, "")
    end
  end
end
