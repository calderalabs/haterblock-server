defmodule Async do
  def perform(function) do
    Task.Supervisor.async_nolink(Haterblock.TaskSupervisor, function)
  end

  def perform(function, delay) do
    Task.Supervisor.async_nolink(Haterblock.TaskSupervisor, fn ->
      :timer.sleep(delay)
      function.()
    end)
  end
end
