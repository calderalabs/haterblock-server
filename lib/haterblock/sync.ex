defmodule Haterblock.Sync do
  import Ecto.Query

  def sync_comments do
    Haterblock.Accounts.list_users()
    |> Parallel.pmap(fn user ->
      sync_user_comments(user)
    end)
  end

  def sync_user_comments(user) do
    user
    |> perform_syncing
    |> finish_syncing
  end

  defp perform_syncing(
         user,
         %{page: page, new_comment_count: new_comment_count} \\ %{page: nil, new_comment_count: 0}
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

    new_comment_count = new_comment_count + Enum.count(new_comments)

    if next_page && Enum.member?(new_comments, last_comment) &&
         Enum.member?(recent_comments, last_comment) do
      perform_syncing(user, %{
        page: next_page,
        new_comment_count: new_comment_count
      })
    else
      {:ok, user} = Haterblock.Accounts.update_user(user, %{synced_at: DateTime.utc_now()})
      %{user: user, new_comment_count: new_comment_count}
    end
  end

  defp finish_syncing(%{user: user, new_comment_count: new_comment_count})
       when new_comment_count > 0 do
    # Haterblock.Emails.new_negative_comments(user, new_comment_count)
    # |> Haterblock.Mailer.deliver_now()

    HaterblockWeb.Endpoint.broadcast("user:#{user.id}", "syncing_updated", %{
      synced_at: user.synced_at,
      new_comment_count: new_comment_count
    })
  end

  defp finish_syncing(_) do
    :ok
  end
end
