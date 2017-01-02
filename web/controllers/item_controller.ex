defmodule PriceCrawler.ItemController do
  use PriceCrawler.Web, :controller

  plug :assign_order
  plug Coherence.Authentication.Session, [protected: true]

  alias PriceCrawler.Item

  def index(conn, _params) do
    items =
      Repo.all(assoc(conn.assigns[:order], :items))
      |> Repo.preload(:product)
    render(conn, "index.html", items: items)
  end

  def new(conn, _params) do
    changeset =
      conn.assigns[:order]
      |> build_assoc(:items)
      |> Item.changeset()
    products = Repo.all(PriceCrawler.Product)
    render(conn, "new.html", changeset: changeset, products: products)
  end

  def create(conn, %{"item" => item_params}) do
    changeset =
      conn.assigns[:order]
      |> build_assoc(:items)
      |> Item.changeset(item_params)

    case Repo.insert(changeset) do
      {:ok, _item} ->
        conn
        |> put_flash(:info, "Item created successfully.")
        |> redirect(to: order_item_path(conn, :index, conn.assigns[:order]))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    item = Repo.get!(assoc(conn.assigns[:order], :items), id) |> Repo.preload(:product)
    render(conn, "show.html", item: item)
  end

  def edit(conn, %{"id" => id}) do
    item = Repo.get!(assoc(conn.assigns[:order], :items), id)
    products = Repo.all(PriceCrawler.Product)
    changeset = Item.changeset(item)
    render(conn, "edit.html", item: item, changeset: changeset, products: products)
  end

  def update(conn, %{"id" => id, "item" => item_params}) do
    item = Repo.get!(assoc(conn.assigns[:order], :items), id)
    changeset = Item.changeset(item, item_params)

    case Repo.update(changeset) do
      {:ok, item} ->
        conn
        |> put_flash(:info, "Item updated successfully.")
        |> redirect(to: order_item_path(conn, :show, conn.assigns[:order], item))
      {:error, changeset} ->
        render(conn, "edit.html", item: item, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    item = Repo.get!(assoc(conn.assigns[:order], :items), id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(item)

    conn
    |> put_flash(:info, "Item deleted successfully.")
    |> redirect(to: order_item_path(conn, :index, conn.assigns[:order]))
  end

  defp assign_order(conn, _opts) do
    case conn.params do
      %{"order_id" => order_id} ->
        case Repo.get(PriceCrawler.Order, order_id) do
          nil -> invalid_order(conn)
          order -> assign(conn, :order, order)
        end
      _ -> invalid_order(conn)
    end
  end

  defp invalid_order(conn) do
    conn
    |> put_flash(:error, "Invalid order!")
    |> redirect(to: order_path(conn, :index))
    |> halt
  end
end
