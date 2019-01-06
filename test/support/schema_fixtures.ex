defmodule JsonSchemaRegistryWeb.SchemaFixtures do
  def valid_attrs(attrs \\ %{}) do
    Map.merge(
      %{
        content: valid_json_schema(),
        name: "some-name",
        namespace: "some-namespace"
      },
      attrs
    )
  end

  def invalid_attrs(attrs \\ %{}) do
    valid_attrs(%{name: nil})
  end

  def update_attrs() do
    %{
      content: %{"type" => "number"},
      name: "some-updated-name",
      namespace: "some-updated-namespace",
      version: 43
    }
  end

  def valid_json_schema do
    %{"type" => "string"}
  end

  def invalid_json_schema do
    %{"foo" => "bar"}
  end
end
