defmodule Agileup.Router do
  use Agileup.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :assign_version
  end

  pipeline :janrain do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :put_secure_browser_headers
    plug :assign_version
  end

  pipeline :browser_session do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Agileup do
    pipe_through [:browser, :browser_session]

    get "/", PageController, :index
    post "/submit_goal", PageController, :submit_goal

    resources "/users", UserController

    get "/login", SessionController, :new
  end

  scope "/", Agileup do
    pipe_through :janrain
    post "/login", SessionController, :create
  end

  defp assign_version(conn, _params) do
    assign(conn, :version, get_version)
  end

  defp get_version do
    Application.get_env(:agileup, :version)
  end

  # Other scopes may use custom stacks.
  # scope "/api", Agileup do
  #   pipe_through :api
  # end
end
