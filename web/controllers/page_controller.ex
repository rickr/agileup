defmodule Agileup.PageController do
  require Logger
  use Agileup.Web, :controller
  use Guardian.Phoenix.Controller

  import Agileup.Router.Helpers
  alias Agileup.Endpoint

  plug Guardian.Plug.EnsureAuthenticated, handler: Agileup.Access


  # If our user doesn't have a name or webhook setup redirect them to the settings page
  def index(conn, _params, %Agileup.User{name: nil} = user, _claims), do: redirect_to_settings(conn)
  def index(conn, _params, %Agileup.User{slack_webhook: nil} = user, _claims), do: redirect_to_settings(conn)

  def index(conn, _params, user, _claims) do
    render conn, "index.html"
  end

  def submit_goal(conn, %{"submit_goal" => %{"goal_input" => goal}}) do
    conn
    |> assign(:goal, goal)
    |> send_to_slack(goal)
    |> render("goal_submitted.html")
  end

  defp redirect_to_settings(conn) do
    conn
    |> redirect to: user_path(Endpoint, :edit)
  end


  defp send_to_slack(conn, goal) do
    Logger.info "Sending #{goal} to slack via webhook \"#{webhook_url}\""
    spawn fn -> HTTPoison.post!(webhook_url, generate_payload_for(goal)) end
    conn
  end

  defp webhook_url do
    Application.get_env(:agileup, :webhook_url)
  end

  defp generate_payload_for(goal) do
    "{\"text\": \"Today my goal is:\n#{goal}\"}"
  end
end
