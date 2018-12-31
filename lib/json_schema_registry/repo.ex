defmodule JsonSchemaRegistry.Repo do
  use Ecto.Repo,
    otp_app: :json_schema_registry,
    adapter: Ecto.Adapters.Postgres
end
