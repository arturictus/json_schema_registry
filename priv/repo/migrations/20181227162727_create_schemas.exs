defmodule JsonSchemaRegistry.Repo.Migrations.CreateSchemas do
  use Ecto.Migration

  def change do
    create table(:schemas) do
      add :name, :string
      add :version, :integer
      add :namespace, :string
      add :content, :map

      timestamps()
    end
  end
end
