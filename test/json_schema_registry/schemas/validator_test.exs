defmodule JsonSchemaRegistry.Schemas.ValidatorTest do
  use ExUnit.Case, async: true
  doctest JsonSchemaRegistry.Schemas.Validator
  import JsonSchemaRegistry.Schemas.Validator
  @valid_json_schema %{"type" => "string"}
  @invalid_json_schema "foo"

  test "valid_json_schema?/1" do
    assert valid_json_schema?(@valid_json_schema)
    refute valid_json_schema?(@invalid_json_schema)
    refute valid_json_schema?(%{"foo" => "bar"})
    refute valid_json_schema?(1)
  end

  test "valid_json_schema?/1 with json" do
    assert valid_json_schema?(Jason.encode!(@valid_json_schema))
    refute valid_json_schema?(Jason.encode!(@invalid_json_schema))
  end

  test "validate_json_schema/1" do
    assert :ok = validate_json_schema(@valid_json_schema)
    assert {:error, _} = validate_json_schema(@invalid_json_schema)
    assert {:error, _} = validate_json_schema(%{"foo" => "bar"})
    assert {:error, _} = validate_json_schema(1)
    assert {:error, _} = validate_json_schema("sfasd")
    assert {:error, _} = validate_json_schema(nil)
  end

  test "validate/2" do
    assert :ok = validate(%{"type" => "string"}, "foo")
    assert {:error, _} = validate(%{"type" => "string"}, 1)
  end
end
