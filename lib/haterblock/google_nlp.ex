defmodule Haterblock.GoogleNlp do
  def assign_sentiment_scores(comments) do
    comments |> Parallel.pmap(&assign_sentiment_score/1)
  end

  def assign_sentiment_score(comment) do
    {:ok, response} =
      conn()
      |> GoogleApi.Language.V1.Api.Documents.language_documents_analyze_sentiment([
        {:key, System.get_env("GOOGLE_API_KEY")},
        {:body,
         %{
           document: %{
             type: "PLAIN_TEXT",
             content: comment.body
           }
         }}
      ])

    %{comment | score: trunc(response.documentSentiment.score * 10)}
  end

  defp conn do
    GoogleApi.Language.V1.Connection.new()
  end
end
