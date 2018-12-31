use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :json_schema_registry, JsonSchemaRegistryWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :json_schema_registry, JsonSchemaRegistry.Repo,
  username: "postgres",
  password: "postgres",
  database: "json_schema_registry_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
