defmodule Haterblock.GoogleNlpTestApi do
  def new_connection do
    %{}
  end

  def language_documents_analyze_sentiment(_, _) do
    {:ok, %{documentSentiment: %{score: 0}}}
  end
end
