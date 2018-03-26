defmodule Haterblock.Youtube do
  defp request(user, fun) do
    result = fun.(user)

    case result do
      {:ok, response} ->
        {:ok, response, user}

      {:error,
       %{
         headers: %{
           "www-authenticate" =>
             "Bearer realm=\"https://accounts.google.com/\", error=invalid_token"
         }
       }} ->
        body = [
          client_id: System.get_env("GOOGLE_CLIENT_ID"),
          client_secret: System.get_env("GOOGLE_CLIENT_SECRET"),
          refresh_token: user.google_refresh_token,
          grant_type: "refresh_token"
        ]

        with {:ok, %HTTPoison.Response{body: body}} <-
               HTTPoison.post("https://www.googleapis.com/oauth2/v4/token", {:form, body}, [
                 {"Content-Type", "application/x-www-form-urlencoded"}
               ]) do
          %{"access_token" => access_token} = body |> Poison.decode!()

          {:ok, updated_user} =
            user |> Haterblock.Accounts.update_user(%{google_token: access_token})

          request(updated_user, fun)
        end
    end
  end

  def list_comments(user, %{page: page} \\ %{page: nil}) do
    %{channels: channels, user: user} = user |> list_channels
    channel = channels |> Enum.at(0)

    %{comment_threads: comment_threads, next_page: next_page, user: user} =
      user |> list_comment_threads(channel, page)

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

    comments =
      comments
      |> Enum.sort_by(& &1.snippet.publishedAt, &>=/2)
      |> Haterblock.Comments.Comment.from_youtube_comments()
      |> Enum.map(fn comment ->
        %{comment | user_id: user.id}
      end)

    %{comments: comments, next_page: next_page}
  end

  defp conn(user) do
    GoogleApi.YouTube.V3.Connection.new(user.google_token)
  end

  defp list_channels(user) do
    {:ok, %{items: channels}, user} =
      request(user, fn user ->
        conn = conn(user)

        GoogleApi.YouTube.V3.Api.Channels.youtube_channels_list(conn, "contentDetails", [
          {:mine, true}
        ])
      end)

    %{channels: channels, user: user}
  end

  defp list_comment_threads(user, channel, page) do
    {:ok, %{items: comment_threads, nextPageToken: next_page}, user} =
      request(user, fn user ->
        conn = conn(user)

        GoogleApi.YouTube.V3.Api.CommentThreads.youtube_comment_threads_list(
          conn,
          "id,snippet,replies",
          [
            {:allThreadsRelatedToChannelId, channel.id},
            {:pageToken, page}
          ]
        )
      end)

    %{comment_threads: comment_threads, next_page: next_page, user: user}
  end
end
