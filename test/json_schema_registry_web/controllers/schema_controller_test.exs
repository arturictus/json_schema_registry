defmodule JsonSchemaRegistryWeb.SchemaControllerTest do
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

  describe "index" do
    test "lists all schemas", %{conn: conn} do
      conn = get(conn, Routes.schema_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create schema" do
    test "renders schema when data is valid", %{conn: conn} do
      conn = post(conn, Routes.schema_path(conn, :create), schema: valid_attrs())
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.schema_path(conn, :show, id))
      _json_schema = valid_json_schema()

      assert %{
               "id" => id,
               "content" => _json_schema,
               "name" => "some-name",
               "namespace" => "some-namespace",
               "version" => 1
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.schema_path(conn, :create), schema: invalid_attrs())
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update schema" do
    setup [:create_schema]

    test "renders schema when data is valid", %{conn: conn, schema: %Schema{id: id} = schema} do
      conn = put(conn, Routes.schema_path(conn, :update, schema), schema: update_attrs())
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.schema_path(conn, :show, id))

      assert %{
               "id" => id,
               "content" => %{"type" => "number"},
               "name" => "some-updated-name",
               "namespace" => "some-updated-namespace",
               "version" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, schema: schema} do
      conn = put(conn, Routes.schema_path(conn, :update, schema), schema: invalid_attrs())
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete schema" do
    setup [:create_schema]

    test "deletes chosen schema", %{conn: conn, schema: schema} do
      conn = delete(conn, Routes.schema_path(conn, :delete, schema))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.schema_path(conn, :show, schema))
      end
    end
  end

  defp create_schema(_) do
    schema = fixture(:schema)
    {:ok, schema: schema}
  end
end
