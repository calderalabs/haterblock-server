defmodule HaterblockWeb.UserChannel do
  use Phoenix.Channel

  def join("user:" <> user_id, _, socket) do
    if socket.assigns.user_id == String.to_integer(user_id) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end
end
