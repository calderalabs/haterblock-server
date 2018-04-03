defmodule Haterblock.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Haterblock.Repo, []),
      # Start the endpoint when the application starts
      supervisor(HaterblockWeb.Endpoint, []),
      supervisor(Task.Supervisor, [[name: Haterblock.TaskSupervisor]])
    ]

    children =
      if System.get_env("ENABLE_SYNC_WORKER") == "true" do
        children ++ [worker(Haterblock.SyncWorker, [])]
      else
        children
      end

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Haterblock.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    HaterblockWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
