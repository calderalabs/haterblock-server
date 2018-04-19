defmodule HaterblockWeb.CommentView do
  use HaterblockWeb, :view
  alias HaterblockWeb.CommentView
  alias Haterblock.Comments.Comment

  def render("index.json", %{collection: collection}) do
    %{
      data: render_many(collection.entries, CommentView, "comment.json"),
      meta: %{
        total_pages: collection.total_pages,
        total_entries: collection.total_entries
      }
    }
  end

  def render("show.json", %{comment: comment}) do
    %{data: render_one(comment, CommentView, "comment.json")}
  end

  def render("comment.json", %{comment: comment}) do
    %{
      id: comment.id,
      attributes: %{
        body: comment.body,
        sentiment: Comment.sentiment_from_score(comment.score),
        status: comment.status,
        published_at: comment.published_at,
        video_id: comment.video_id
      }
    }
  end
end
