defmodule JsonSchemaRegistry.SchemasTest do
  use JsonSchemaRegistry.DataCase

  alias JsonSchemaRegistry.Schemas

  describe "schemas" do
    alias JsonSchemaRegistry.Schemas.Schema
    import JsonSchemaRegistryWeb.SchemaFixtures

    def schema_fixture(attrs \\ %{}) do
      {:ok, schema} =
        attrs
        |> Enum.into(valid_attrs())
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

    test "get_schema/2 returns the schema by namespace and name" do
      schema = schema_fixture()
      assert Schemas.get_schema!(schema.namespace, schema.name) == schema
    end

    test "get_schema/3 returns the schema by namespace and name" do
      schema = schema_fixture()
      assert Schemas.get_schema!(schema.namespace, schema.name, schema.version) == schema
    end

    test "create_schema/1 with valid data creates a schema" do
      assert {:ok, %Schema{} = schema} = Schemas.create_schema(valid_attrs())
      assert schema.content == valid_attrs().content
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
      assert {:ok, %Schema{} = schema} = Schemas.update_schema(schema, valid_attrs(%{content: %{ "type" => "number" }}))
      assert schema.content == %{ "type" => "number" }
      assert schema.name == valid_attrs().name
      assert schema.namespace == valid_attrs().namespace
      assert schema.version == 1
    end

    test "update_schema/2 with invalid data returns error changeset" do
      schema = schema_fixture()
      assert {:error, %Ecto.Changeset{}} = Schemas.update_schema(schema, invalid_attrs())
      assert schema == Schemas.get_schema!(schema.id)
    end

    test "delete_schema/1 deletes the schema" do
      schema = schema_fixture()
      assert {:ok, %Schema{}} = Schemas.delete_schema(schema)
      assert_raise Ecto.NoResultsError, fn -> Schemas.get_schema!(schema.id) end
    end

    test "change_schema/1 returns a schema changeset" do
      schema = schema_fixture()
      assert %Ecto.Changeset{} = Schemas.change_schema(schema)
    end
  end
end
