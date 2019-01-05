defmodule JsonSchemaRegistryWeb.RepoController do
  use JsonSchemaRegistryWeb, :controller
  alias JsonSchemaRegistry.Schemas
  alias JsonSchemaRegistry.Schemas.Schema

  action_fallback JsonSchemaRegistryWeb.FallbackController

  def get(conn, _params) do
    %{"namespace" => namespace, "name" => name} = conn.path_params
    schema = Schemas.get_schema!(namespace, name)
    render(conn, "show.json", schema: schema)
  end

  def get_version(conn, _params) do
    %{"namespace" => namespace, "name" => name, "version" => version} = conn.path_params
    schema = Schemas.get_schema!(namespace, name, version)
    render(conn, "show.json", schema: schema)
  end
end
