defmodule JsonSchemaRegistryWeb.RepoControllerTest do
  use JsonSchemaRegistryWeb.ConnCase

  alias JsonSchemaRegistry.Schemas
  alias JsonSchemaRegistry.Schemas.Schema
  import JsonSchemaRegistryWeb.SchemaFixtures

  def fixture(:schema) do
    {:ok, schema} = Schemas.create_schema(valid_attrs())
    schema
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "get" do
    test "When empty raises error", %{conn: conn} do
      assert_raise Ecto.NoResultsError, fn ->
        get(conn, Routes.repo_path(conn, :get, "foo", "bar"))
      end
    end

    test "When exists returns the json_schema", %{conn: conn}  do
      schema = fixture(:schema)
      conn = get(conn, Routes.repo_path(conn, :get, schema.namespace, schema.name))
      body = schema.content
      assert body = json_response(conn, 200)
    end
  end

  describe "get_version" do
    test "When empty raises error", %{conn: conn} do
      assert_raise Ecto.NoResultsError, fn ->
        get(conn, Routes.repo_path(conn, :get_version, "foo", "bar", 2))
      end
    end

    test "When exists returns the json_schema", %{conn: conn}  do
      schema = fixture(:schema)
      conn = get(conn, Routes.repo_path(conn, :get_version, schema.namespace, schema.name, schema.version))
      body = schema.content
      assert body = json_response(conn, 200)
    end
  end

  defp create_schema(_) do
    schema = fixture(:schema)
    {:ok, schema: schema}
  end
end
