defmodule BetWeb.Router do
  alias BetWeb.AdminLive
  use BetWeb, :router

  def user_auth(conn, _opts) do
    current_user = conn.assigns[:current_user]

    if current_user.role.name == "frontend-access" do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in as a user to access this page")
      |> redirect(to: "/login")
      |> halt()
    end
  end

  def admin_auth(conn, _opts) do
    current_user = conn.assigns[:current_user]

    if current_user.role.name == "admin" || current_user.role.name == "superuser" do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in as an admin to access this page")
      |> redirect(to: "/login")
      |> halt()
    end
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {BetWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :auth do
    plug BetWeb.Auth
  end

  pipeline :users_auth do
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BetWeb do
    pipe_through :browser

    get "/", PageController, :home

    live "/signup", RegistrationLive.Index, :new
    live "/login", LoginLive.Index, :new

    post "/users/login", UsersLoginController, :login
  end

  scope "/users", BetWeb do
    pipe_through [:browser, :auth, :user_auth]

    live "/", UsersLive.Index, :index
    live "/bets", UsersLive.Bets, :index
  end

  scope "/admin" do
    pipe_through [:browser, :auth, :admin_auth]

    live "/", AdminLive.Index, :index
    live "/sports", AdminLive.Sports, :index
    live "/bets/:id", AdminLive.ViewBets
    live "/profits", AdminLive.Profits
  end

  # Other scopes may use custom stacks.
  # scope "/api", BetWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:bet, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: BetWeb.Telemetry
      # forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
