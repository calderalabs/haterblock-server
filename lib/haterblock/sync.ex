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
         %{page: page, last_comment: last_comment} \\ %{page: nil, last_comment: nil}
       ) do
    %{next_page: next_page, comments: youtube_comments} =
      user |> Haterblock.Youtube.list_comments(%{page: page})

    last_comment_query =
      from(
        c in Haterblock.Comments.Comment,
        where: c.user_id == ^user.id,
        order_by: [desc: c.inserted_at]
      )
      |> first

    last_comment = last_comment || Haterblock.Repo.one(last_comment_query)

    new_youtube_comments =
      youtube_comments
      |> Enum.take_while(fn youtube_comment ->
        !last_comment || youtube_comment.google_id != last_comment.google_id
      end)
      |> Haterblock.GoogleNlp.assign_sentiment_scores()

    new_youtube_comments |> Enum.each(&Haterblock.Repo.insert/1)

    if new_youtube_comments |> Enum.member?(youtube_comments |> List.last()) do
      sync_user_comments(user, %{page: next_page, last_comment: last_comment})
    else
      :ok
    end
  end
end
