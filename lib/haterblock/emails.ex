defmodule Haterblock.Emails do
  import Bamboo.Email

  def new_negative_comments(user, count) do
    base_email(user)
    |> subject("You have #{count} new negative #{Inflex.inflect("comments", count)} to review.")
    |> html_body("<strong>Welcome</strong>")
    |> text_body("welcome")
  end

  defp base_email(user) do
    new_email()
    |> to({user.name, user.email})
    |> from({"Haterblock", "noreply@gethaterblock.com"})
    |> put_header("X-SES-SOURCE-ARN", System.get_env("SES_DOMAIN_IDENTITY_ARN"))
    |> put_header("X-SES-FROM-ARN", System.get_env("SES_DOMAIN_IDENTITY_ARN"))
    |> put_header("X-SES-RETURN-PATH-ARN", System.get_env("SES_DOMAIN_IDENTITY_ARN"))
  end
end
