defmodule JsonSchemaRegistry.Schemas.Schema do
  use Ecto.Schema
  import Ecto.Changeset

  import JsonSchemaRegistry.Schemas.Validator,
    only: [validate_json_schema: 1]

  schema "schemas" do
    field :content, :map
    field :name, :string
    field :namespace, :string, default: "default"
    field :version, :integer, default: 1

    timestamps()
  end

  @doc false
  def changeset(schema, attrs) do
    schema
    |> cast(attrs, [:name, :version, :namespace, :content])
    |> validate_required([:name, :version, :namespace, :content])
    |> validate_content
    |> validate_identifier(:name)
    |> validate_identifier(:namespace)
    |> unique_constraint(:name, name: :schemas_namespace_name_version_index)
  end

  def validate_identifier(changeset, field) do
    changeset
    |> validate_length(field, min: 3, max: 100)
    |> validate_format(field, ~r/^[a-z\-_]+$/)
  end

  def validate_content(changeset) do
    validate_change(changeset, :content, fn :content, content ->
      case validate_json_schema(content) do
        :ok -> []
        {:error, error} -> [:content, error]
      end
    end)
  end
end
