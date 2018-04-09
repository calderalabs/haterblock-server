defmodule Haterblock.Sync do
  import Ecto.Query

  def sync_comments do
    Haterblock.Accounts.list_users()
    |> Parallel.pmap(fn user ->
      sync_user_comments(user)
    end)
  end

  def sync_user_comments(user, %{notify: notify} \\ %{notify: true}) do
    user
    |> perform_syncing
    |> finish_syncing(notify)
  end

  defp perform_syncing(
         user,
         %{page: page, new_comments: new_comments} \\ %{page: nil, new_comments: []}
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

    page_new_comments =
      recent_comments
      |> Enum.filter(fn comment ->
        !(existing_comments_ids |> Enum.member?(comment.google_id))
      end)
      |> Haterblock.GoogleNlp.assign_sentiment_scores()

    page_new_comments |> Enum.each(&Haterblock.Repo.insert/1)
    last_comment = comments |> List.last()

    new_comments = new_comments ++ page_new_comments

    if next_page && Enum.member?(new_comments, last_comment) &&
         Enum.member?(recent_comments, last_comment) do
      perform_syncing(user, %{
        page: next_page,
        new_comments: new_comments
      })
    else
      {:ok, user} = Haterblock.Accounts.update_user(user, %{synced_at: DateTime.utc_now()})
      %{user: user, new_comments: new_comments}
    end
  end

  defp finish_syncing(%{user: user, new_comments: new_comments}, notify) do
    if notify do
      negative_comments =
        new_comments
        |> Enum.filter(&(Haterblock.Comments.Comment.sentiment_from_score(&1.score) == :negative))

      negative_comment_count = Enum.count(negative_comments)

      if negative_comment_count > 0 do
        HaterblockWeb.Email.new_negative_comments(user, negative_comment_count)
        |> Haterblock.Mailer.deliver_now()
      end
    end

    new_comment_count = Enum.count(new_comments)

    if new_comment_count > 0 do
      HaterblockWeb.Endpoint.broadcast("user:#{user.id}", "syncing_updated", %{
        synced_at: user.synced_at,
        new_comment_count: new_comment_count
      })
    else
      :ok
    end
  end
end
