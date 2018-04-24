use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :haterblock, HaterblockWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :haterblock, Haterblock.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "haterblock_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :haterblock,
  youtube_api: Haterblock.YoutubeTestApi,
  youtube_connection: Haterblock.YoutubeTestConnection,
  google_language_api: Haterblock.GoogleLanguageTestApi,
  google_language_connection: Haterblock.GoogleLanguageTestConnection
