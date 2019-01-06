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

  def create(conn, content) do
    %{"namespace" => namespace, "name" => name} = conn.path_params

    case Schemas.create_or_update(namespace, name, clean_content(conn, content)) do
      {:ok, schema} ->
        render(conn, "show.json", schema: schema)

      {:error, changeset} ->
        put_status(conn, 400)
        |> render("errors.json", changeset: changeset)
    end
  end

  # TODO: remove name and namespace
  defp clean_content(conn, content) do
    content
  end
end
