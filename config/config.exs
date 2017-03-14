# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :jose_invalid_curve_attack, JoseInvalidCurveAttack.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "+6ry3iVMZ1/ind6z3z7NbhHqb/CNA2YB0+mfp9z7Ubc2skIlaYmv1nfkfhxR5vAp",
  render_errors: [view: JoseInvalidCurveAttack.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: JoseInvalidCurveAttack.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure phoenix format encoders
config :phoenix, :format_encoders,
  json: JOSEFormatEncoder

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
