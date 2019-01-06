defmodule JsonSchemaRegistry.Schemas do
  @moduledoc """
  The Schemas context.
  """

  import Ecto.Query, warn: false
  alias JsonSchemaRegistry.Repo

  alias JsonSchemaRegistry.Schemas.Schema

  @doc """
  Returns the list of schemas.

  ## Examples

      iex> list_schemas()
      [%Schema{}, ...]

  """
  def list_schemas do
    Repo.all(Schema)
  end

  @doc """
  Gets a single schema.

  Raises `Ecto.NoResultsError` if the Schema does not exist.

  ## Examples

      iex> get_schema!(123)
      %Schema{}

      iex> get_schema!(456)
      ** (Ecto.NoResultsError)

  """
  def get_schema!(id), do: Repo.get!(Schema, id)

  def get_schema!(namespace, name) do
    q = from s in schema_q(namespace, name), order_by: [desc: s.version], limit: 1
    Repo.one!(q)
  end

  def get_schema!(namespace, name, version) do
    Repo.get_by!(Schema, namespace: namespace, name: name, version: version)
  end

  def get_schema(namespace, name) do
    q = from s in schema_q(namespace, name), order_by: [desc: s.version], limit: 1
    Repo.one(q)
  end

  defp schema_q(namespace, name) do
    from s in Schema, where: s.namespace == ^namespace and s.name == ^name
  end

  # TODO: test
  def get_all(namespace, name) do
    schema_q(namespace, name)
    |> Repo.all()
  end

  @doc """
  Creates a schema.

  ## Examples

      iex> create_schema(%{field: value})
      {:ok, %Schema{}}

      iex> create_schema(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_schema(attrs \\ %{}) do
    %Schema{}
    |> Schema.changeset(attrs)
    |> Repo.insert()
  end

  # TODO: test
  def create_or_update(namespace, name, content) do
    exists = get_schema(namespace, name)

    if exists do
      update_schema(namespace, name, content)
    else
      create_schema(%{namespace: namespace, name: name, content: content})
    end
  end

  @doc """
  Updates a schema.

  ## Examples

      iex> update_schema(schema, %{field: new_value})
      {:ok, %Schema{}}

      iex> update_schema(schema, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_schema(%Schema{} = schema, attrs) do
    schema
    |> Schema.changeset(attrs)
    |> Repo.update()
  end

  def update_schema(namespace, name, content) do
    prev = get_schema!(namespace, name)

    create_schema(%{
      namespace: prev.namespace,
      name: prev.name,
      version: prev.version + 1,
      content: content
    })
  end

  @doc """
  Deletes a Schema.

  ## Examples

      iex> delete_schema(schema)
      {:ok, %Schema{}}

      iex> delete_schema(schema)
      {:error, %Ecto.Changeset{}}

  """
  def delete_schema(%Schema{} = schema) do
    Repo.delete(schema)
  end

  def delete_schema(namespace, name) do
    schema_q(namespace, name)
    |> Repo.delete_all()
  end

  def delete_schema(namespace, name, version) do
    get_schema!(namespace, name, version)
    |> Repo.delete!()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking schema changes.

  ## Examples

      iex> change_schema(schema)
      %Ecto.Changeset{source: %Schema{}}

  """
  def change_schema(%Schema{} = schema) do
    Schema.changeset(schema, %{})
  end
end
