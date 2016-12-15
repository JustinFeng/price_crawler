defmodule PriceCrawler.ProductController do
  use PriceCrawler.Web, :controller

  alias PriceCrawler.Product

  def index(conn, params) do
    products = case params do
      %{"search" => %{"key" => search_key}} -> from p in Product, where: ilike(p.name, ^"%#{search_key}%")
      _ -> Product
    end
    |> Repo.all
    |> Repo.preload(:vendor)
    |> Repo.preload(prices: from(p in PriceCrawler.Price, order_by: [desc: p.updated_at]))
    |> Enum.sort(fn(p1, p2) ->
      case {Enum.at(p1.prices, 0), Enum.at(p2.prices, 0)} do
        {nil, _} -> false
        {_, nil} -> true
        {p1_price, p2_price} -> Ecto.DateTime.compare(p1_price.updated_at, p2_price.updated_at) == :gt
      end
    end)
    render(conn, "index.html", products: products)
  end

  def new(conn, _params) do
    changeset = Product.changeset(%Product{})
    vendors = Repo.all(PriceCrawler.Vendor)
    render(conn, "new.html", changeset: changeset, vendors: vendors)
  end

  def create(conn, %{"product" => product_params}) do
    changeset = Product.changeset(%Product{}, product_params)

    case Repo.insert(changeset) do
      {:ok, _product} ->
        conn
        |> put_flash(:info, "Product created successfully.")
        |> redirect(to: product_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    product = Repo.get!(Product, id) |> Repo.preload(:vendor)
    render(conn, "show.html", product: product)
  end

  def edit(conn, %{"id" => id}) do
    product = Repo.get!(Product, id)
    vendors = Repo.all(PriceCrawler.Vendor)
    changeset = Product.changeset(product)
    render(conn, "edit.html", product: product, changeset: changeset, vendors: vendors)
  end

  def update(conn, %{"id" => id, "product" => product_params}) do
    product = Repo.get!(Product, id)
    changeset = Product.changeset(product, product_params)

    case Repo.update(changeset) do
      {:ok, product} ->
        conn
        |> put_flash(:info, "Product updated successfully.")
        |> redirect(to: product_path(conn, :show, product))
      {:error, changeset} ->
        render(conn, "edit.html", product: product, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    product = Repo.get!(Product, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(product)

    conn
    |> put_flash(:info, "Product deleted successfully.")
    |> redirect(to: product_path(conn, :index))
  end
end
