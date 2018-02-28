defmodule HaterblockWeb.PageController do
  use HaterblockWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
