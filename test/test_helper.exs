ExUnit.start()

{:ok, _} = Haterblock.YoutubeTestApi.start_link()
{:ok, _} = Haterblock.GoogleNlpTestApi.start_link()
Ecto.Adapters.SQL.Sandbox.mode(Haterblock.Repo, :manual)
