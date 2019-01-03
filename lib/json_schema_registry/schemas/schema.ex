defmodule JsonSchemaRegistry.Schemas.Schema do
  use Ecto.Schema
  import Ecto.Changeset
  import JsonSchemaRegistry.Schemas.Validator, only: [valid_json_schema?: 1, validate_json_schema: 1]

  schema "schemas" do
    field :content, :map
    field :name, :string
    field :namespace, :string
    field :version, :integer

    timestamps()
  end

  @doc false
  def changeset(schema, attrs) do
    schema
    |> cast(attrs, [:name, :version, :namespace, :content])
    |> validate_required([:name, :version, :namespace, :content])
    |> validate_content
  end

  def validate_content(changeset) do
    validate_change(changeset, :content, fn(:content, body) ->
      if valid_json_schema?(body) do
        []
      else
        [:content, 'Invalid schema']
      end
    end)
  end
end
