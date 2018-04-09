defmodule HaterblockWeb.Email do
  use Bamboo.Phoenix, view: HaterblockWeb.EmailView

  def new_negative_comments(user, count) do
    base_email(user)
    |> subject("You have #{count} new negative #{Inflex.inflect("comments", count)}.")
    |> assign(:count, count)
    |> render("new_negative_comments.html")
    |> premail()
  end

  defp base_email(user) do
    new_email()
    |> to({user.name, user.email})
    |> from({"Haterblock", "noreply@gethaterblock.com"})
    |> put_header("X-SES-SOURCE-ARN", System.get_env("SES_DOMAIN_IDENTITY_ARN"))
    |> put_layout({HaterblockWeb.LayoutView, :email})
    |> assign(:user_name, user.name)
  end

  defp premail(email) do
    html = Premailex.to_inline_css(email.html_body)
    text = Premailex.to_text(email.html_body)

    email
    |> html_body(html)
    |> text_body(text)
  end
end
