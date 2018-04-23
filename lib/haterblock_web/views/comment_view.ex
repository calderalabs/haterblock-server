defmodule HaterblockWeb.CommentView do
  use HaterblockWeb, :view
  alias HaterblockWeb.CommentView
  alias Haterblock.Comments.Comment

  def render("index.json", %{collection: collection, counts: counts}) do
    %{
      data: render_many(collection.entries, CommentView, "comment.json"),
      meta: %{
        total_pages: collection.total_pages,
        total_entries: collection.total_entries,
        counts: %{
          hateful_comments: counts.hateful_comments,
          negative_comments: counts.negative_comments,
          neutral_comments: counts.neutral_comments,
          positive_comments: counts.positive_comments,
          rejected_comments: counts.rejected_comments,
          published_comments: counts.published_comments
        }
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
