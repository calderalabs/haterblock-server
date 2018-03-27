defmodule HaterblockWeb.CommentView do
  use HaterblockWeb, :view
  alias HaterblockWeb.CommentView

  def render("index.json", %{comments: comments}) do
    %{data: render_many(comments, CommentView, "comment.json")}
  end

  def render("show.json", %{comment: comment}) do
    %{data: render_one(comment, CommentView, "comment.json")}
  end

  def render("comment.json", %{comment: comment}) do
    %{
      id: comment.id,
      attributes: %{body: comment.body, score: comment.score, status: comment.status}
    }
  end
end
