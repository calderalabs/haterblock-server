# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :haterblock, ecto_repos: [Haterblock.Repo]

# Configures the endpoint
config :haterblock, HaterblockWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "8zVRVif4NpQTtBfV5YtbIuEgiYB8k6Pewfbiplwii87QPPi8+JoGEB34DpGGUZqq",
  render_errors: [view: HaterblockWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Haterblock.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :ueberauth, Ueberauth,
  providers: [
    google: {Ueberauth.Strategy.Google, [callback_methods: ["POST"]]}
  ]

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: System.get_env("GOOGLE_CLIENT_ID"),
  client_secret: System.get_env("GOOGLE_CLIENT_SECRET")

config :tesla, :adapter, :ibrowse

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
