defmodule GalaxyWeb.Router do
  use GalaxyWeb, :router

  import GalaxyWeb.Auth, only: [authenticate_user: 2]

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {GalaxyWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug GalaxyWeb.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GalaxyWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/users", UserController, :index
    get "/users/new", UserController, :new
    post "/users", UserController, :create
    get "/users/:id/edit", UserController, :edit
    put "/users/:id", UserController, :update
    get "/users/:id", UserController, :show
    delete "/users/:id", UserController, :delete

    resources "/sessions", SessionController, only: [:new, :create, :delete]
    get "/watch/:id", WatchController, :show
    resources "/annotations", AnnotationController, only: [:create]

    resources "/comments", CommentController do
      post "/:id/summarize", CommentController, :summarize, as: :summarize
    end

    # Poll routes for creating, editing, and displaying polls
    resources "/polls", PollController

    # Custom voting route
    post "/polls/:id/vote", PollController, :vote, as: :vote  # Voting route
  end

  scope "/", GalaxyWeb do
    pipe_through [:browser, :authenticate_user]

    resources "/videos", VideoController
  end

  scope "/manage", GalaxyWeb do
    pipe_through [:browser, :authenticate_user]

    resources "/videos", VideoController
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:galaxy, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: GalaxyWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
