Postgrex.Types.define(
  JsonSchemaRegistry.PostgrexTypes,
  [] ++ Ecto.Adapters.Postgres.extensions(),
  json: Jason
)
