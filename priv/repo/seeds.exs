# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     JsonSchemaRegistry.Repo.insert!(%JsonSchemaRegistry.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
JsonSchemaRegistry.Schemas.create_schema(%{
  name: "example",
  namespace: "tutorial",
  content: %{"type" => "string"},
  version: 1
})
