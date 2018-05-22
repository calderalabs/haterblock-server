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
  google_nlp_api: Haterblock.GoogleNlpTestApi,
  async: TestAsync

config :haterblock, Haterblock.Mailer, adapter: Bamboo.TestAdapter

config :bamboo, :refute_timeout, 10
