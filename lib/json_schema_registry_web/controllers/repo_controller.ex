defmodule JsonSchemaRegistryWeb.RepoController do
  use JsonSchemaRegistryWeb, :controller
  alias JsonSchemaRegistry.Schemas
  alias JsonSchemaRegistry.Schemas.Schema

  action_fallback JsonSchemaRegistryWeb.FallbackController

  def show(conn, _params, %{"namespace" => namespace, "name" => name, "version" => version}) do
    schema = Schemas.get_schema!(namespace, name, version)
    render(conn, "show.json", schema: schema)
  end

  def show(conn, _params, %{"namespace" => namespace, "name" => name}) do
    schema = Schemas.get_schema!(namespace, name)
    render(conn, "show.json", schema: schema)
  end

  def create(conn, content, %{"namespace" => namespace, "name" => name}) do
    case Schemas.create_or_update(namespace, name, content) do
      {:ok, schema} ->
        render(conn, "show.json", schema: schema)

      {:error, changeset} ->
        put_status(conn, 400)
        |> render("errors.json", changeset: changeset)
    end
  end

  def delete(conn, _params, %{"namespace" => namespace, "name" => name, "version" => version}) do
    Schemas.delete_schema(namespace, name, version)
    |> delete_response(conn)
  end

  def delete(conn, _params, %{"namespace" => namespace, "name" => name}) do
    Schemas.delete_schema(namespace, name)
    |> delete_response(conn)
  end

  defp delete_response(action, conn) do
    case action do
      {_, nil} ->
        render(conn, "delete.json")

      {:ok, schema} ->
        render(conn, "delete.json", %{schema: schema})

      {:error, changeset} ->
        put_status(conn, 400)
        |> render("errors.json", %{changeset: changeset})
    end
  end

  def action(conn, _) do
    keys = Map.take(conn.path_params, ["name", "namespace", "version"])
    params = Map.drop(conn.params, ["name", "namespace", "version"])
    apply(__MODULE__, action_name(conn), [conn, params, keys])
  end
end
