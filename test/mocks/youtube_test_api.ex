defmodule Haterblock.YoutubeTestApi do
  def new_connection(_) do
    %{}
  end

  def channels_list(_, _, _) do
    {:ok, %{items: []}}
  end

  def comment_threads_list(_, _, _) do
    {:ok, %{items: [], nextPageToken: nil}}
  end

  def comments_set_moderation_status(_, _, _) do
    {:ok, %{}}
  end
end
