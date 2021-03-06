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

    get "/:namespace/:name", JsonSchemaRegistryWeb.RepoController, :show
    post "/:namespace/:name", JsonSchemaRegistryWeb.RepoController, :create
    delete "/:namespace/:name", JsonSchemaRegistryWeb.RepoController, :delete

    get "/:namespace/:name/:version", JsonSchemaRegistryWeb.RepoController, :show
    post "/:namespace/:name/:version", JsonSchemaRegistryWeb.RepoController, :create
    delete "/:namespace/:name/:version", JsonSchemaRegistryWeb.RepoController, :delete
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
