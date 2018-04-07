defmodule HaterblockWeb.ErrorView do
  use HaterblockWeb, :view

  def render("404.json", _assigns) do
    render_error(%{status: 404, title: "Resource Not Found"})
  end

  def render("500.json", _assigns) do
    render_error(%{status: 500, title: "Internal Server Error"})
  end

  def render("401.json", _assigns) do
    render_error(%{status: 401, title: "Unauthorized"})
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render("500.json", assigns)
  end

  defp render_error(%{status: status, title: title}) do
    %{
      errors: [
        %{
          code: Integer.to_string(status),
          title: title
        }
      ]
    }
  end
end
