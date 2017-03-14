defmodule JoseInvalidCurveAttack.Web.Router do
  use JoseInvalidCurveAttack.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :put_secure_browser_headers
  end

  pipeline :csrf do
    plug :protect_from_forgery
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", JoseInvalidCurveAttack.Web do
    pipe_through [:browser, :csrf] # Use the default browser stack

    get "/", PageController, :index
    # Sender
    get "/sender", SenderController, :index
    post "/sender", SenderController, :post_recover
  end

  scope "/", JoseInvalidCurveAttack.Web do
    pipe_through :browser
    # Receiver
    get "/receiver", ReceiverController, :index
    get "/secret", ReceiverController, :post_secret
    post "/secret", ReceiverController, :post_secret
    get "/ecdh-es-public.json", ReceiverController, :get_public_key
  end

  # Other scopes may use custom stacks.
  # scope "/api", JoseInvalidCurveAttack.Web do
  #   pipe_through :api
  # end
end
