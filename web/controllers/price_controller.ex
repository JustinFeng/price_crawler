defmodule PriceCrawler.PriceController do
  use PriceCrawler.Web, :controller

  plug :assign_product
  plug Coherence.Authentication.Session, [protected: true]

  alias PriceCrawler.Price

  def index(conn, _params) do
    prices = Repo.all(from p in assoc(conn.assigns[:product], :prices), order_by: [desc: p.id])
    render(conn, "index.html", prices: prices)
  end

  def new(conn, _params) do
    changeset =
      conn.assigns[:product]
      |> build_assoc(:prices)
      |> Price.changeset(%{type: "manual"})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"price" => price_params}) do
    changeset =
      conn.assigns[:product]
      |> build_assoc(:prices)
      |> Price.changeset(price_params)

    case Repo.insert(changeset) do
      {:ok, _price} ->
        conn
        |> put_flash(:info, "Price created successfully.")
        |> redirect(to: product_price_path(conn, :index, conn.assigns[:product]))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    price = Repo.get!(assoc(conn.assigns[:product], :prices), id)
    render(conn, "show.html", price: price)
  end

  def edit(conn, %{"id" => id}) do
    price = Repo.get!(assoc(conn.assigns[:product], :prices), id)
    changeset = Price.changeset(price)
    render(conn, "edit.html", price: price, changeset: changeset)
  end

  def update(conn, %{"id" => id, "price" => price_params}) do
    price = Repo.get!(assoc(conn.assigns[:product], :prices), id)
    changeset = Price.changeset(price, price_params)

    case Repo.update(changeset) do
      {:ok, price} ->
        conn
        |> put_flash(:info, "Price updated successfully.")
        |> redirect(to: product_price_path(conn, :show, conn.assigns[:product], price))
      {:error, changeset} ->
        render(conn, "edit.html", price: price, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    price = Repo.get!(assoc(conn.assigns[:product], :prices), id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(price)

    conn
    |> put_flash(:info, "Price deleted successfully.")
    |> redirect(to: product_price_path(conn, :index, conn.assigns[:product]))
  end

  defp assign_product(conn, _opts) do
    case conn.params do
      %{"product_id" => product_id} ->
        case Repo.get(PriceCrawler.Product, product_id) do
          nil -> invalid_product(conn)
          product -> assign(conn, :product, product)
        end
      _ -> invalid_product(conn)
    end
  end

  defp invalid_product(conn) do
    conn
    |> put_flash(:error, "Invalid product!")
    |> redirect(to: product_path(conn, :index))
    |> halt
  end
end
