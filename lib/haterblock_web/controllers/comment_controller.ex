defmodule HaterblockWeb.CommentController do
  use HaterblockWeb, :controller

  alias Haterblock.Comments

  action_fallback(HaterblockWeb.FallbackController)

  def index(conn, _params) do
    comments = Comments.list_comments()
    render(conn, "index.json", comments: comments)
  end
end
