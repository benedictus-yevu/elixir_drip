import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :elixir_drip_web, ElixirDripWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "OoqslXLQvKxZnmrnBwgo7rzKi2QFex6+zNUDmfZauXCDtoTgx+v2ougLSGlQ1EPC",
  server: false

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :elixir_drip, ElixirDrip.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "elixir_drip_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10
