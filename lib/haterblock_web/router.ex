defmodule HaterblockWeb.Router do
  use HaterblockWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", HaterblockWeb do
    pipe_through :api

    post "/auth/:provider/callback", AuthController, :callback
  end
end
