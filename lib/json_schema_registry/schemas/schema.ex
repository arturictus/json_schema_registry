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
    |> validate_identifier(:name)
    |> validate_identifier(:namespace)
    |> validate_content()
    |> unique_constraint(:name, name: :schemas_namespace_name_version_index)
    |> prepare_changes(fn changeset -> prepare_content(changeset) end)
  end

  def validate_identifier(changeset, field) do
    changeset
    |> validate_length(field, min: 3, max: 100)
    |> validate_format(field, ~r/^[a-z\-_\d]+$/)
  end

  def validate_content(changeset) do
    validate_change(changeset, :content, fn
      :content, content ->
        case validate_json_schema(content) do
          :ok -> []
          {:error, error} -> [:content, error]
        end
    end)
  end

  def prepare_content(changeset) do
    namespace = get_field(changeset, :namespace)
    name = get_field(changeset, :name)
    version = get_field(changeset, :version)
    change = %{ "$id" => "$DOMAIN/#{namespace}/#{name}/#{version}" }
    content = get_field(changeset, :content)
              |> Map.merge(change)
    changeset
    |> put_change(:content, content)
  end
end
