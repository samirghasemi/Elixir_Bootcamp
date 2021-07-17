# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :discuss,
  ecto_repos: [Discuss.Repo]

# Configures the endpoint
config :discuss, DiscussWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "FziuznpgsaKDFJP9ybSz1EFp+MCtdJ2/lm+9+mUkYbRCnH2gNkQMSdXwLzJQFcyY",
  render_errors: [view: DiscussWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Discuss.PubSub,
  live_view: [signing_salt: "HRJupNie"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"


config :ueberauth, Ueberauth,
  providers: [
    google: {Ueberauth.Strategy.Google, [default_scope: "email profile"]}
  ]
config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: "417697348592-vh8m03qr5ghsnf2283b2bvc7osm89v95.apps.googleusercontent.com",
  client_secret: "uWgdqJzLF85KzJuqlMnDa30p"
  # config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  # client_id: {:system, "837ab12816a921d99592"},
  # client_secret: {:system, "0f9599cb0029729fa004c27bf9ccd6fa3f0e1b91"}
