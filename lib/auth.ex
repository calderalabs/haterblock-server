defmodule Haterblock.Auth do
  import Joken

  @secret Application.get_env(:haterblock, HaterblockWeb.Endpoint)[:secret_key_base]

  def verify_token(token) do
    token
    |> token
    |> with_signer(hs256(@secret))
    |> verify
  end

  def generate_token(claims) do
    claims
    |> token
    |> with_signer(hs256(@secret))
    |> sign
  end
end
