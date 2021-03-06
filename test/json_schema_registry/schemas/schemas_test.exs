defmodule JsonSchemaRegistry.SchemasTest do
  use JsonSchemaRegistry.DataCase

  alias JsonSchemaRegistry.Schemas

  describe "schemas" do
    alias JsonSchemaRegistry.Schemas.Schema
    import JsonSchemaRegistryWeb.SchemaFixtures

    def schema_fixture(attrs \\ %{}) do
      {:ok, schema} =
        attrs
        |> Enum.into(valid_attrs(attrs))
        |> Schemas.create_schema()

      schema
    end

    test "list_schemas/0 returns all schemas" do
      schema = schema_fixture()
      assert Schemas.list_schemas() == [schema]
    end

    test "get_schema!/1 returns the schema with given id" do
      schema = schema_fixture()
      assert Schemas.get_schema!(schema.id) == schema
    end

    test "get_schema/2 returns the schema by namespace and name last version" do
      schema = schema_fixture()
      schema_2 = schema_fixture(%{version: 2, content: %{"type" => "number"}})
      assert Schemas.get_schema!(schema.namespace, schema.name) == schema_2
    end

    test "get_schema/3 returns the schema by namespace and name" do
      schema = schema_fixture()
      assert Schemas.get_schema!(schema.namespace, schema.name, schema.version) == schema
    end

    test "get_schema/2 returns schema by namespace and name or nil" do
      schema = schema_fixture()
      schema_2 = schema_fixture(%{version: 2, content: %{"type" => "number"}})
      assert Schemas.get_schema(schema.namespace, schema.name) == schema_2
      assert Schemas.get_schema(schema.namespace, "not-existent") == nil
    end

    test "create_schema/1 with valid data creates a schema" do
      assert {:ok, %Schema{} = schema} = Schemas.create_schema(valid_attrs())
      _content = valid_attrs().content
      assert _content = schema.content
      assert schema.name == valid_attrs().name
      assert schema.namespace == valid_attrs().namespace
      assert schema.version == 1
    end

    test "create_schema/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Schemas.create_schema(invalid_attrs())
    end

    test "create_schema/1 unique constrain for namespace name version" do
      assert Schemas.create_schema(valid_attrs())
      assert {:error, %Ecto.Changeset{}} = Schemas.create_schema(valid_attrs())
      assert Enum.count(Schemas.list_schemas()) == 1
    end

    test "update_schema/2 with valid data updates the schema" do
      schema = schema_fixture()

      assert {:ok, %Schema{} = schema} =
               Schemas.update_schema(schema, valid_attrs(%{content: %{"type" => "number"}}))

      assert %{"type" => "number"} = schema.content
      assert schema.name == valid_attrs().name
      assert schema.namespace == valid_attrs().namespace
      assert schema.version == 1
    end

    test "update_schema/3 with valid data updates the schema" do
      schema = schema_fixture()

      assert {:ok, %Schema{} = up_schema} =
               Schemas.update_schema(schema.namespace, schema.name, %{"type" => "number"})

      assert up_schema.id != schema.id
      assert %{"type" => "number"} = up_schema.content
      assert up_schema.name == valid_attrs().name
      assert up_schema.namespace == valid_attrs().namespace
      assert up_schema.version == 2
    end

    test "update_schema/2 with invalid data returns error changeset" do
      schema = schema_fixture()
      assert {:error, %Ecto.Changeset{}} = Schemas.update_schema(schema, invalid_attrs())
      assert schema == Schemas.get_schema!(schema.id)
    end

    test "delete_schema/1 deletes all the schema versions" do
      schema = schema_fixture()
      assert {:ok, %Schema{}} = Schemas.delete_schema(schema)
      assert_raise Ecto.NoResultsError, fn -> Schemas.get_schema!(schema.id) end
    end

    test "delete_schema/2 deletes all the schema versions" do
      schema = schema_fixture()
      schema_2 = schema_fixture(%{version: 2, content: %{"type" => "number"}})
      assert {2, nil} = Schemas.delete_schema(schema.namespace, schema.name)
      assert_raise Ecto.NoResultsError, fn -> Schemas.get_schema!(schema.id) end
      assert_raise Ecto.NoResultsError, fn -> Schemas.get_schema!(schema_2.id) end
    end

    test "delete_schema/3 deletes specific schema version" do
      schema = schema_fixture()
      schema_2 = schema_fixture(%{version: 2, content: %{"type" => "number"}})
      assert %Schema{} = Schemas.delete_schema(schema.namespace, schema.name, schema.version)
      assert_raise Ecto.NoResultsError, fn -> Schemas.get_schema!(schema.id) end
      assert Schemas.get_schema!(schema_2.id) == schema_2
    end

    test "change_schema/1 returns a schema changeset" do
      schema = schema_fixture()
      assert %Ecto.Changeset{} = Schemas.change_schema(schema)
    end
  end
end
