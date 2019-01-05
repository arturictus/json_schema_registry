defmodule JsonSchemaRegistry.SchemaTest do
  use JsonSchemaRegistry.DataCase

  alias JsonSchemaRegistry.Schemas.Schema

  describe "schema" do
    @valid_json_schema %{"type" => "string"}
    @invalid_json_schema %{"foo" => "bar"}
    @valid_attrs %{
      content: @valid_json_schema,
      name: "some-name",
      # namespace: "some-namespace",
      # version: 42
    }
    @update_attrs %{
      content: %{"type" => "number"},
      name: "some-updated-name",
      # namespace: "some-updated-namespace",
      # version: 43
    }
    @invalid_attrs %{content: nil, name: nil, namespace: nil, version: nil}

    def changeset(attrs) do
      %Schema{}
      |> Schema.changeset(attrs)
    end

    test "defaults [:namespace, :version]" do
      chs = changeset(@valid_attrs)
      assert chs.valid?
      assert %{version: 1, namespace: "default" } = chs.data
    end

    @tag :skip
    test "unique constrain for [:namespace, :name, :version]" do
      chs = changeset(@valid_attrs)
      assert {:ok, %Schema{}} = Repo.insert(chs)
      n_chs = changeset(@valid_attrs)
      refute n_chs.valid?
      # assert {:error, %Ecto.Changeset{}} = Schemas.create_schema(@valid_attrs)
    end
  end
end
