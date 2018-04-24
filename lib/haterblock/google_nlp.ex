defmodule Haterblock.GoogleNlp do
  @google_language_api Application.get_env(:haterblock, :google_language_api)
  @google_language_connection Application.get_env(:haterblock, :google_language_connection)

  def assign_sentiment_scores(comments) do
    comments |> Parallel.pmap(&assign_sentiment_score/1)
  end

  def assign_sentiment_score(comment) do
    {:ok, response} =
      conn()
      |> @google_language_api.Documents.language_documents_analyze_sentiment([
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
    @google_language_connection.new()
  end
end
