defmodule Haterblock.Youtube do
  def list_comments(user) do
    conn = conn(user)
    channels = conn |> list_channels
    uploads = conn |> list_uploads(channels |> Enum.at(0))

    comment_threads =
      uploads
      |> Enum.flat_map(fn playlist_item ->
        conn |> list_comment_threads(playlist_item.contentDetails.videoId)
      end)

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
    |> Haterblock.Comments.Comment.from_youtube_comments()
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

  defp list_comment_threads(conn, video_id) do
    {:ok, %{items: comment_threads}} =
      GoogleApi.YouTube.V3.Api.CommentThreads.youtube_comment_threads_list(
        conn,
        "id,snippet,replies",
        [
          {:videoId, video_id}
        ]
      )

    comment_threads
  end

  defp list_uploads(conn, channel) do
    uploads_playlist = channel.contentDetails.relatedPlaylists.uploads

    {:ok, %{items: uploads}} =
      GoogleApi.YouTube.V3.Api.PlaylistItems.youtube_playlist_items_list(conn, "contentDetails", [
        {:playlistId, uploads_playlist}
      ])

    uploads
  end
end
