defmodule Async do
  def perform(function) do
    Task.Supervisor.async_nolink(Haterblock.TaskSupervisor, function)
  end
end
