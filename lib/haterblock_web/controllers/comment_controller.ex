defmodule HaterblockWeb.CommentController do
  use HaterblockWeb, :controller

  alias Haterblock.Comments

  action_fallback(HaterblockWeb.FallbackController)
  plug(HaterblockWeb.Plugs.Authenticated)

  def index(conn, _params) do
    comments = Comments.list_comments_for_user(conn.assigns.current_user)
    render(conn, "index.json", comments: comments)
  end
end
