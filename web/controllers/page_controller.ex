defmodule Agileup.PageController do
  use Agileup.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def submit_goal(conn, %{"submit_goal" => %{"goal_input" => goal}}) do
    conn
    |> assign(:goal, goal)
    |> send_to_slack(goal)
    |> render("goal_submitted.html")
  end


  defp send_to_slack(conn, goal) do
    IO.puts "Sending #{goal} to slack"
    HTTPoison.post!(webhook_url, generate_payload_for(goal))
    conn
  end

  defp webhook_url do
    "https://hooks.slack.com/services/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"
  end

  defp generate_payload_for(goal) do
    "{\"text\": \"Today my goal is:\n#{goal}\"}"
  end
end
