defmodule Haterblock.GoogleNlpTestApi do
  use Agent

  def start_link do
    Agent.start_link(fn -> %{documents: %{}} end, name: __MODULE__)
  end

  def new_connection do
    %{}
  end

  def language_documents_analyze_sentiment(_, key: _, body: body) do
    {:ok,
     Agent.get(
       __MODULE__,
       &(Map.get(&1, :documents)
         |> Map.get(body.document.content, %{documentSentiment: %{score: 0}}))
     )}
  end

  def put_documents(documents) do
    Agent.update(__MODULE__, &Map.put(&1, :documents, documents))
  end

  def reset() do
    Agent.update(__MODULE__, &Map.put(&1, :documents, %{}))
  end
end
