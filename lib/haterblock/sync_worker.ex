defmodule Haterblock.SyncWorker do
  @default_interval Integer.to_string(5 * 60 * 1000)
  @interval String.to_integer(System.get_env("SYNC_WORKER_INTERVAL") || @default_interval)

  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    Haterblock.Sync.sync_comments()
    schedule_work()
    {:noreply, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, @interval)
  end
end
