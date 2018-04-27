defmodule Haterblock.YoutubeTestApi do
  use Agent

  def start_link do
    Agent.start_link(fn -> %{comments: []} end, name: __MODULE__)
  end

  def new_connection(_) do
    %{}
  end

  def channels_list(_, _, _) do
    {:ok,
     %{
       items: [
         %{
           id: "1"
         }
       ]
     }}
  end

  def comment_threads_list(_, _, _) do
    {:ok,
     %{
       items:
         Agent.get(__MODULE__, &Map.get(&1, :comments))
         |> Enum.map(fn comment ->
           %{
             snippet: %{
               topLevelComment: comment
             }
           }
         end),
       nextPageToken: nil
     }}
  end

  def comments_set_moderation_status(_, _, _) do
    {:ok, nil}
  end

  def put_comments(comments) do
    Agent.update(__MODULE__, &Map.put(&1, :comments, comments))
  end

  def reset() do
    Agent.update(__MODULE__, &Map.put(&1, :comments, []))
  end
end
