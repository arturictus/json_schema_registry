defmodule JsonSchemaRegistry.SchemaTest do
  use JsonSchemaRegistry.DataCase

  alias JsonSchemaRegistry.Schemas.Schema
  import JsonSchemaRegistryWeb.SchemaFixtures

  describe "schema" do
    def changeset(attrs) do
      %Schema{}
      |> Schema.changeset(attrs)
    end

    test "defaults [:namespace, :version]" do
      chs = changeset(valid_attrs())
      assert chs.valid?
      assert %{version: 1, namespace: "default"} = chs.data
    end

    @tag :skip
    test "unique constrain for [:namespace, :name, :version]" do
      chs = changeset(valid_attrs())
      assert {:ok, %Schema{}} = Repo.insert(chs)
      n_chs = changeset(valid_attrs())
      refute n_chs.valid?
      # assert {:error, %Ecto.Changeset{}} = Schemas.create_schema(valid_attrs())
    end
  end
end
