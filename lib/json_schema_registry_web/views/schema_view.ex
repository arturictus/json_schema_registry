defmodule JsonSchemaRegistryWeb.SchemaView do
  use JsonSchemaRegistryWeb, :view
  alias JsonSchemaRegistryWeb.SchemaView

  def render("index.json", %{schemas: schemas}) do
    %{data: render_many(schemas, SchemaView, "schema.json")}
  end

  def render("show.json", %{schema: schema}) do
    %{data: render_one(schema, SchemaView, "schema.json")}
  end

  def render("schema.json", %{schema: schema}) do
    %{
      id: schema.id,
      name: schema.name,
      version: schema.version,
      namespace: schema.namespace,
      content: schema.content
    }
  end
end
