defmodule Haterblock.Sync do
  import Ecto.Query

  def sync_comments do
    Haterblock.Accounts.list_users()
    |> Enum.each(fn user ->
      sync_user_comments(user)
    end)
  end

  defp sync_user_comments(
         user,
         %{page: page} \\ %{page: nil}
       ) do
    %{next_page: next_page, comments: youtube_comments} =
      user |> Haterblock.Youtube.list_comments(%{page: page})

    existing_youtube_comments_ids =
      from(
        c in Haterblock.Comments.Comment,
        select: c.google_id,
        where: c.google_id in ^Enum.map(youtube_comments, & &1.google_id)
      )
      |> Haterblock.Repo.all()

    new_youtube_comments =
      youtube_comments
      |> Enum.filter(fn youtube_comment ->
        !(existing_youtube_comments_ids |> Enum.member?(youtube_comment.google_id))
      end)
      |> Haterblock.GoogleNlp.assign_sentiment_scores()

    new_youtube_comments |> Enum.each(&Haterblock.Repo.insert/1)

    if next_page && Enum.count(new_youtube_comments) == Enum.count(youtube_comments) do
      sync_user_comments(user, %{page: next_page})
    else
      :ok
    end
  end
end
