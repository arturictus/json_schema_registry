defmodule JsonSchemaRegistryWeb.Router do
  use JsonSchemaRegistryWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    resources "/schemas", JsonSchemaRegistryWeb.SchemaController, except: [:new, :edit]
    resources "/:namespace/:name", JsonSchemaRegistryWeb.RepoController, except: [:new, :edit, :update]
    resources "/:namespace/:name/:version", JsonSchemaRegistryWeb.RepoController, except: [:new, :edit, :update, :index]
  end

  scope "/", JsonSchemaRegistryWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", JsonSchemaRegistryWeb do
  #   pipe_through :api
  # end
end
