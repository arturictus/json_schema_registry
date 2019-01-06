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

    test "sets $id in the schema" do
      attrs = valid_attrs()
      chs = changeset(attrs)
      assert chs.valid?
      %Schema{content: %{"$id" => id }} = Repo.insert!(chs)
      assert id =~ "$DOMAIN/#{attrs.namespace}/#{attrs.name}"
    end

    test "unique constrain for [:namespace, :name, :version]" do
      chs = changeset(valid_attrs())
      assert {:ok, %Schema{}} = Repo.insert(chs)
      n_chs = changeset(valid_attrs())
      assert {:error, changeset} = Repo.insert(n_chs)
      assert [name: {"has already been taken", _}] = changeset.errors
    end
  end
end
