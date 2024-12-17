defmodule LepatriinuWeb.Router do
  # alias LepatriinuWeb.PollCreationLive
  use LepatriinuWeb, :router

  import LepatriinuWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {LepatriinuWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LepatriinuWeb do
    pipe_through [:browser, :require_authenticated_user]

    live "/", PollsLive, :index
    live "/new", PollCreationLive, :new
    live "/:poll_id", PollDetailsLive, :show
  end

  ## Authentication routes

  scope "/", LepatriinuWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{LepatriinuWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", LepatriinuWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
  end
end
