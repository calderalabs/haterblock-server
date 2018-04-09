defmodule Haterblock.Mixfile do
  use Mix.Project

  def project do
    [
      app: :haterblock,
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Haterblock.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.3.0"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.2"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},
      {:ueberauth, "~> 0.4"},
      {:ueberauth_google, github: "calderalabs/ueberauth_google", tag: "v0.7.1"},
      {:cors_plug, "~> 1.5"},
      {:joken, "~> 1.5"},
      {:google_api_you_tube, "~> 0.0.1"},
      {:google_api_language, "~> 0.0.1"},
      {:poison, "~> 3.1"},
      {:httpoison, "~> 1.0"},
      {:ibrowse, "~> 4.4.0"},
      {:scrivener_ecto, "~> 1.0"},
      {:timex, "~> 3.1"},
      {:sentry, "~> 6.1.0"},
      {:bamboo, "~> 0.8"},
      {:inflex, "~> 1.10.0"},
      {:bamboo_smtp, "~> 1.4.0"},
      {:premailex, "~> 0.1"},
      {:phoenix_html, "~> 2.10"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
