defmodule Haterblock.GoogleNlpApi do
  def new_connection do
    GoogleApi.Language.V1.Connection.new()
  end

  def language_documents_analyze_sentiment(conn, documents) do
    GoogleApi.Language.V1.Api.Documents.language_documents_analyze_sentiment(conn, documents)
  end
end
