defmodule HaterblockWeb.CommentController do
  use HaterblockWeb, :controller

  alias Haterblock.Comments

  action_fallback(HaterblockWeb.FallbackController)
  plug(HaterblockWeb.Plugs.Authenticated)

  def index(conn, params) do
    collection =
      Comments.list_comments_for_user(conn.assigns.current_user, %{
        sentiments:
          params |> Map.get("sentiment") |> String.split(",") |> Enum.reject(&(&1 == "")),
        statuses: params |> Map.get("status") |> String.split(",") |> Enum.reject(&(&1 == "")),
        page: params |> Map.get("page")
      })

    counts = Comments.counts_for_user(conn.assigns.current_user)

    render(conn, "index.json", collection: collection, counts: counts)
  end
end
