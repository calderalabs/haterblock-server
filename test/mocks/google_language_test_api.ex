defmodule Haterblock.GoogleLanguageTestApi do
  defmodule Documents do
    def language_documents_analyze_sentiment(_, _) do
      %{documentSentiment: %{score: 0}}
    end
  end
end
