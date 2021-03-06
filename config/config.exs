# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :agileup, Agileup.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "+LmydJNefX+mK25fmxKc4pvEgSRgGK4JOOOUGVBIpe7DRTjP+RoHtVte91eHO0IL",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: Agileup.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure Slack
config :agileup, webhook_url: System.get_env("WEBHOOK_URL")

# Configure version
{:ok, version} = File.read("version")
version = version |> String.rstrip(?\n)
config :agileup, version: version

# Configure Janrain
config :agileup, :janrain_api_url, System.get_env("JANRAIN_API_URL")
config :agileup, :janrain_api_key, System.get_env("JANRAIN_API_KEY")

# Configure Guardian
config :guardian, Guardian,
  issuer: "AgileUp",
  ttl: { 30, :days },
  secret_key: "490eadf849a007a162d5e0cc0263740d351a7f80",
  serializer: AgileUp.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false

