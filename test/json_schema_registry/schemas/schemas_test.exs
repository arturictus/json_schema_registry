defmodule JsonSchemaRegistry.SchemasTest do
  use JsonSchemaRegistry.DataCase

  alias JsonSchemaRegistry.Schemas

  describe "schemas" do
    alias JsonSchemaRegistry.Schemas.Schema
    @valid_json_schema %{"type" => "string"}
    @invalid_json_schema %{"foo" => "bar"}
    @valid_attrs %{
      content: @valid_json_schema,
      name: "some-name",
      namespace: "some-namespace",
      version: 42
    }
    @update_attrs %{
      content: %{"type" => "number"},
      name: "some-updated-name",
      namespace: "some-updated-namespace",
      version: 43
    }
    @invalid_attrs %{content: nil, name: nil, namespace: nil, version: nil}

    def schema_fixture(attrs \\ %{}) do
      {:ok, schema} =
        attrs
        |> Enum.into(@valid_attrs)
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

    test "create_schema/1 with valid data creates a schema" do
      assert {:ok, %Schema{} = schema} = Schemas.create_schema(@valid_attrs)
      assert schema.content == @valid_json_schema
      assert schema.name == "some-name"
      assert schema.namespace == "some-namespace"
      assert schema.version == 42
    end

    test "create_schema/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Schemas.create_schema(@invalid_attrs)
    end

    test "update_schema/2 with valid data updates the schema" do
      schema = schema_fixture()
      assert {:ok, %Schema{} = schema} = Schemas.update_schema(schema, @update_attrs)
      assert schema.content == %{ "type" => "number" }
      assert schema.name == "some-updated-name"
      assert schema.namespace == "some-updated-namespace"
      assert schema.version == 43
    end

    test "update_schema/2 with invalid data returns error changeset" do
      schema = schema_fixture()
      assert {:error, %Ecto.Changeset{}} = Schemas.update_schema(schema, @invalid_attrs)
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
