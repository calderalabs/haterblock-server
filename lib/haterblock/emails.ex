defmodule Haterblock.Emails do
  import Bamboo.Email

  @from {"Haterblock", "noreply@gethaterblock.com"}

  def new_negative_comments(user, count) do
    new_email()
    |> to({user.name, user.email})
    |> from(@from)
    |> subject("You have #{count} new negative #{Inflex.inflect("comments", count)} to review.")
    |> html_body("<strong>Welcome</strong>")
    |> text_body("welcome")
  end
end
