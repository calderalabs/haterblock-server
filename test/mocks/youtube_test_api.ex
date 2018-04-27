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

  def comment_threads_list(_, _, options) do
    comments = Agent.get(__MODULE__, &Map.get(&1, :comments))
    page = options[:pageToken] || 0

    pages =
      if Enum.empty?(comments) do
        [[]]
      else
        comments |> Enum.chunk_every(2)
      end

    next_page_token =
      if Enum.count(pages) - 1 == page do
        nil
      else
        page + 1
      end

    {:ok,
     %{
       items:
         pages
         |> Enum.at(page)
         |> Enum.map(fn comment ->
           %{
             snippet: %{
               topLevelComment: comment
             }
           }
         end),
       nextPageToken: next_page_token
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
