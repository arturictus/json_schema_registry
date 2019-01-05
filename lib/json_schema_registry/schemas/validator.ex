defmodule JsonSchemaRegistry.Schemas.Validator do
  @doc ~S"""
  Validates schema agains meta-schema

  examples:

      iex> JsonSchemaRegistry.Schemas.Validator.valid_json_schema?("foo")
      false
      iex> JsonSchemaRegistry.Schemas.Validator.valid_json_schema?(~s({"type":"string"}))
      true
      iex> JsonSchemaRegistry.Schemas.Validator.valid_json_schema?(%{"type" => "string"})
      true
  """
  def valid_json_schema?(content) when is_bitstring(content) do
    case Jason.decode(content) do
      {:ok, map} -> valid_json_schema?(map)
      _ -> false
    end
  end

  def valid_json_schema?(content) when is_map(content) do
    meta_schema()
    |> ExJsonSchema.Schema.resolve()
    |> ExJsonSchema.Validator.valid?(content)
  end

  def valid_json_schema?(_), do: false

  @doc ~S"""
  validates schema against meta-schema

  examples:

      iex> JsonSchemaRegistry.Schemas.Validator.validate_json_schema(%{"type" => "string"})
      :ok
      iex> JsonSchemaRegistry.Schemas.Validator.validate_json_schema(1)
      {:error, [{"Type mismatch. Expected Object but got Integer.", "#"}]}
  """
  def validate_json_schema(schema) do
    meta_schema()
    |> validate(schema)
  end

  @doc ~S"""
  Given schema and data validates the data against the schema

  examples:

      iex> JsonSchemaRegistry.Schemas.Validator.validate(%{"type" => "string"}, "foo")
      :ok
      iex> JsonSchemaRegistry.Schemas.Validator.validate(%{"type" => "string"}, 1)
      {:error, [{"Type mismatch. Expected String but got Integer.", "#"}]}
  """
  def validate(schema, data) when is_bitstring(schema) do
    Jason.decode!(schema)
    |> validate(data)
  end

  def validate(schema, data) do
    schema
    |> ExJsonSchema.Schema.resolve()
    |> ExJsonSchema.Validator.validate(data)
  end

  defp meta_schema do
    Path.expand("json_schema_4.json", __DIR__)
    |> File.read!()
    |> Jason.decode!()
  end
end
