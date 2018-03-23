defmodule Haterblock.Youtube do
  def list_comments(user, %{page: page} \\ %{page: 1}) do
    conn = conn(user)
    channel = conn |> list_channels |> Enum.at(0)
    comment_threads = conn |> list_comment_threads(channel)

    comments =
      comment_threads
      |> Enum.flat_map(fn comment_thread ->
        replies =
          if comment_thread.replies != nil do
            comment_thread.replies.comments
          else
            []
          end

        [comment_thread.snippet.topLevelComment] ++ replies
      end)

    comments
    |> Enum.sort_by(& &1.snippet.publishedAt, &>=/2)
    |> Haterblock.Comments.Comment.from_youtube_comments()
    |> Enum.map(fn comment ->
      %{comment | user_id: user.id}
    end)
  end

  defp conn(user) do
    GoogleApi.YouTube.V3.Connection.new(user.google_token)
  end

  defp list_channels(conn) do
    {:ok, %{items: channels}} =
      GoogleApi.YouTube.V3.Api.Channels.youtube_channels_list(conn, "contentDetails", [
        {:mine, true}
      ])

    channels
  end

  defp list_comment_threads(conn, channel) do
    {:ok, %{items: comment_threads}} =
      GoogleApi.YouTube.V3.Api.CommentThreads.youtube_comment_threads_list(
        conn,
        "id,snippet,replies",
        [
          {:allThreadsRelatedToChannelId, channel.id}
        ]
      )

    comment_threads
  end
end
