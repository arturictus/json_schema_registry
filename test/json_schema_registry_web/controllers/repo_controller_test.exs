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

  describe "show" do
    test "When empty raises error", %{conn: conn} do
      assert_raise Ecto.NoResultsError, fn ->
        get(conn, Routes.repo_path(conn, :show, "foo", "bar"))
      end
    end

    test "When exists returns the json_schema", %{conn: conn} do
      schema = fixture(:schema)
      conn = get(conn, Routes.repo_path(conn, :show, schema.namespace, schema.name))
      _body = schema.content
      assert _body = json_response(conn, 200)
    end
  end

  describe "show with version parameter" do
    test "When empty raises error", %{conn: conn} do
      assert_raise Ecto.NoResultsError, fn ->
        get(conn, Routes.repo_path(conn, :show, "foo", "bar", 2))
      end
    end

    test "When exists returns the json_schema", %{conn: conn} do
      schema = fixture(:schema)

      conn =
        get(
          conn,
          Routes.repo_path(conn, :show, schema.namespace, schema.name, schema.version)
        )

      _body = schema.content
      assert _body = json_response(conn, 200)
    end
  end

  describe "create" do
    test "when does not exist creates one", %{conn: conn} do
      attrs = valid_attrs()

      conn =
        post(
          conn,
          Routes.repo_path(conn, :create, attrs.namespace, attrs.name, attrs.content)
        )

      _body = attrs.content
      assert _body = json_response(conn, 200)
      assert %Schema{} = Schemas.get_schema!(attrs.namespace, attrs.name)
    end

    test "when exists creates one with bumped version", %{conn: conn} do
      schema = fixture(:schema)

      conn =
        post(
          conn,
          Routes.repo_path(conn, :create, schema.namespace, schema.name, %{"type" => "number"})
        )

      assert %{"type" => "number"} = json_response(conn, 200)
      assert %Schema{} = Schemas.get_schema!(schema.namespace, schema.name)
    end

    @tag :skip
    test "when exists creates error", %{conn: conn} do
      schema = fixture(:schema)

      conn =
        post(
          conn,
          Routes.repo_path(conn, :create, schema.namespace, schema.name, %{"foo" => "bar"})
        )

      assert %{"errors" => _} = json_response(conn, 400)
      assert %Schema{} = Schemas.get_schema!(schema.namespace, schema.name)
    end
  end

  describe "delete" do
    setup [:create_schema]

    test "namespace name", %{conn: conn, schema: schema} do
      conn =
        delete(
          conn,
          Routes.repo_path(conn, :delete, schema.namespace, schema.name)
        )

      _body = schema.content
      assert _body = json_response(conn, 200)

      assert_raise Ecto.NoResultsError, fn ->
        Schemas.get_schema!(schema.namespace, schema.name)
      end
    end
  end

  defp create_schema(_) do
    schema = fixture(:schema)
    {:ok, schema: schema}
  end
end
