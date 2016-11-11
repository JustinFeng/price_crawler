defmodule PriceCrawler.Router do
  use PriceCrawler.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PriceCrawler do
    pipe_through :browser # Use the default browser stack

    get "/", ProductController, :index
    post "/", ProductController, :index
    
    resources "/vendors", VendorController
    resources "/products", ProductController do
      resources "/prices", PriceController
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", PriceCrawler do
  #   pipe_through :api
  # end
end
