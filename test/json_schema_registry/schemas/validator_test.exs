defmodule JsonSchemaRegistry.Schemas.ValidatorTest do
  use ExUnit.Case, async: true
  doctest JsonSchemaRegistry.Schemas.Validator
  import JsonSchemaRegistry.Schemas.Validator
  @valid_json_schema %{"type" => "string"}
  @invalid_json_schema "foo"

  test "valid_json_schema?/1" do
    assert valid_json_schema?(@valid_json_schema)
    assert valid_json_schema?(Jason.encode!(@valid_json_schema))
    refute valid_json_schema?(@invalid_json_schema)
    refute valid_json_schema?(Jason.encode!(@invalid_json_schema))

    refute valid_json_schema?(1)
  end
end
