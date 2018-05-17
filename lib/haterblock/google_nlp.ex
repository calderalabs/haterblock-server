defmodule Haterblock.GoogleNlp do
  defp google_nlp_api do
    Application.get_env(:haterblock, :google_nlp_api)
  end

  def assign_sentiment_scores(comments) do
    comments |> Parallel.pmap(&assign_sentiment_score/1)
  end

  def assign_sentiment_score(comment) do
    result =
      conn()
      |> google_nlp_api().language_documents_analyze_sentiment([
        {:key, System.get_env("GOOGLE_API_KEY")},
        {:body,
         %{
           document: %{
             type: "PLAIN_TEXT",
             content: comment.body
           }
         }}
      ])

    case result do
      {:ok, response} ->
        %{comment | score: trunc(response.documentSentiment.score * 10)}

      {:error, %{status: 400}} ->
        %{comment | score: 0}
    end
  end

  defp conn do
    google_nlp_api().new_connection()
  end
end
