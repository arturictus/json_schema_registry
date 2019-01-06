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
  def valid_json_schema?(content) do
    case validate_json_schema(content) do
      :ok -> true
      _ -> false
    end
  end

  @doc ~S"""
  validates schema against meta-schema

  examples:

      iex> JsonSchemaRegistry.Schemas.Validator.validate_json_schema(%{"type" => "string"})
      :ok
      iex> r = JsonSchemaRegistry.Schemas.Validator.validate_json_schema(1)
      iex> match?({:error, _}, r)
      true
  """
  def validate_json_schema(schema) when is_bitstring(schema) do
    case Jason.decode(schema) do
      {:ok, map} -> validate_json_schema(map)
      _ -> {:error, "Unable to decode JSON"}
    end
  end

  def validate_json_schema(schema) when is_map(schema) do
    with :ok <- meta_schema() |> validate(schema),
         :ok <- validate_json_schema(schema, :type) do
      :ok
    else
      error -> error
    end
  end

  def validate_json_schema(_) do
    {:error, [{"schema is not a map", "#"}]}
  end

  def validate_json_schema(schema, :type) when is_map(schema) do
    if Map.has_key?(schema, "type") do
      :ok
    else
      {:error, [{"schema must contain property `type`", "#"}]}
    end
  end

  def validate_json_schema(_, :type) do
    {:error, [{"schema is not a map", "#"}]}
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
