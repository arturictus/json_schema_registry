defmodule JsonSchemaRegistryWeb.RepoView do
  use JsonSchemaRegistryWeb, :view

  def render("show.json", %{schema: schema}) do
    schema.content
  end
end
