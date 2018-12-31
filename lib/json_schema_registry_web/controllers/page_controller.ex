defmodule JsonSchemaRegistryWeb.PageController do
  use JsonSchemaRegistryWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
