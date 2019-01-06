defmodule JsonSchemaRegistryWeb.RepoView do
  use JsonSchemaRegistryWeb, :view

  def render("show.json", %{schema: schema}) do
    schema.content
  end

  def render("errors.json", %{changeset: changeset}) do
    %{errors: inspect(changeset.errors)}
  end
  def render("delete.json", %{schema: schema}) do
    schema
  end
end
