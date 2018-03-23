defmodule HaterblockWeb.CommentController do
  use HaterblockWeb, :controller

  alias Haterblock.Comments

  action_fallback(HaterblockWeb.FallbackController)

  def index(conn, _params) do
    comments = Comments.list_comments()
    render(conn, "index.json", comments: comments)
  end

  def update(conn, %{"id" => id, "comment" => comment_params}) do
    # comment = Comments.get_comment!(id)

    # with {:ok, %Comment{} = comment} <- Comments.update_comment(comment, comment_params) do
    #   render(conn, "show.json", comment: comment)
    # end

    json(conn, %{})
  end
end
