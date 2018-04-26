defmodule Haterblock.YoutubeTestApi do
  defmodule Channels do
    def youtube_channels_list(_, _, _) do
      {:ok, %{items: []}}
    end
  end

  defmodule CommentThreads do
    def youtube_comment_threads_list(_, _, _) do
      {:ok, %{items: [], nextPageToken: nil}}
    end
  end

  defmodule Comments do
    def youtube_comments_set_moderation_status(_, _, _) do
      {:ok, %{}}
    end
  end
end
