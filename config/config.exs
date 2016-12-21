# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :price_crawler,
  ecto_repos: [PriceCrawler.Repo]

# Configures the endpoint
config :price_crawler, PriceCrawler.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "DnAvVPZMyUkJOyBKeoR7MJffQmB/Li7rJNzFv3gY7kW2plZHKRJxwQ6tYDBfwSE9",
  render_errors: [view: PriceCrawler.ErrorView, accepts: ~w(html json)],
  pubsub: [name: PriceCrawler.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :money,
  default_currency: :AUD,
  separator: ",",
  delimeter: "."

# %% Coherence Configuration %%   Don't remove this line
config :coherence,
  user_schema: PriceCrawler.User,
  repo: PriceCrawler.Repo,
  module: PriceCrawler,
  logged_out_url: "/",
  email_from_name: "Your Name",
  email_from_email: "yourname@example.com",
  opts: [:authenticatable, :recoverable, :lockable, :trackable, :unlockable_with_token]

config :coherence, PriceCrawler.Coherence.Mailer,
  adapter: Swoosh.Adapters.Sendgrid,
  api_key: "your api key here"
# %% End Coherence Configuration %%
