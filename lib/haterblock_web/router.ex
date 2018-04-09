defmodule HaterblockWeb.Router do
  use HaterblockWeb, :router

  use Plug.ErrorHandler
  use Sentry.Plug

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", HaterblockWeb do
    pipe_through(:api)

    post("/auth/:provider/callback", AuthController, :callback)
    get("/users/me", UserController, :show)
    resources("/comments", CommentController, only: [:index])
    resources("/rejections", RejectionController, only: [:create])
  end

  if Mix.env() == :dev do
    forward("/sent_emails", Bamboo.EmailPreviewPlug)
  end
end
