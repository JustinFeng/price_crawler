defmodule PriceCrawler.Router do
  use PriceCrawler.Web, :router
  use Coherence.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :browser
    coherence_routes
  end

  scope "/", PriceCrawler do
    pipe_through :browser # Use the default browser stack

    get "/", ProductController, :index
    post "/", ProductController, :index
    
    resources "/vendors", VendorController
    resources "/products", ProductController do
      resources "/prices", PriceController
    end

    resources "/orders", OrderController do
      resources "/items", ItemController
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", PriceCrawler do
  #   pipe_through :api
  # end
end
