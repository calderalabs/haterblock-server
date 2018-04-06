defmodule Haterblock.Auth do
  import Joken

  def verify_token(token) do
    token
    |> token
    |> with_signer(hs256(System.get_env("SECRET_KEY_BASE")))
    |> verify
  end

  def generate_token(claims) do
    claims
    |> token
    |> with_signer(hs256(System.get_env("SECRET_KEY_BASE")))
    |> sign
  end
end
