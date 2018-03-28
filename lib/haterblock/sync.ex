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
    %{next_page: next_page, comments: comments} =
      user |> Haterblock.Youtube.list_comments(%{page: page})

    recent_comments =
      comments
      |> Enum.filter(fn comment ->
        DateTime.compare(comment.published_at, Timex.shift(Timex.now(), days: -7)) != :lt
      end)

    existing_comments_ids =
      from(
        c in Haterblock.Comments.Comment,
        select: c.google_id,
        where: c.google_id in ^Enum.map(recent_comments, & &1.google_id)
      )
      |> Haterblock.Repo.all()

    new_comments =
      recent_comments
      |> Enum.filter(fn comment ->
        !(existing_comments_ids |> Enum.member?(comment.google_id))
      end)
      |> Haterblock.GoogleNlp.assign_sentiment_scores()

    new_comments |> Enum.each(&Haterblock.Repo.insert/1)
    last_comment = comments |> List.last()

    if next_page && Enum.member?(new_comments, last_comment) &&
         Enum.member?(recent_comments, last_comment) do
      sync_user_comments(user, %{page: next_page})
    else
      :ok
    end
  end
end
