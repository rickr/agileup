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

  def submit_goal(conn, %{"submit_goal" => %{"goal_input" => goal}}, user, _claims) do
    conn
    |> assign(:goal, goal)
    |> send_to_slack(user, goal)
    |> render("goal_submitted.html")
  end

  defp redirect_to_settings(conn) do
    conn
    |> redirect to: user_path(Endpoint, :edit)
  end


  defp send_to_slack(conn, user, goal) do
    Logger.info "Sending #{user.name}'s #{goal} to slack via webhook \"#{user.slack_webhook}\""
    spawn fn -> HTTPoison.post!(user.slack_webhook, generate_payload_for(user, goal)) end
    conn
  end

  defp generate_payload_for(user, goal) do
    "{\"text\": \"Today #{user.name}'s goal is:\n#{goal}\"}"
  end
end
