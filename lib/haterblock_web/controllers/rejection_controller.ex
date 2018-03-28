defmodule HaterblockWeb.RejectionController do
  use HaterblockWeb, :controller

  alias Haterblock.Comments

  action_fallback(HaterblockWeb.FallbackController)
  plug(HaterblockWeb.Plugs.Authenticated)

  def create(conn, %{"rejection" => %{"ids" => ids}}) do
    comments = Comments.list_comments(ids)

    with {:ok, _} <- Comments.reject_comments(comments, conn.assigns.current_user) do
      json(conn, %{})
    end
  end
end
