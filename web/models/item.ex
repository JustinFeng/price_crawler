defmodule PriceCrawler.Item do
  use PriceCrawler.Web, :model

  schema "items" do
    field :price, Money.Ecto.Type
    field :quantity, :integer
    field :total, Money.Ecto.Type
    belongs_to :order, PriceCrawler.Order
    belongs_to :product, PriceCrawler.Product

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    derived_params = case params do
      %{"price" => price, "quantity" => quantity} ->
        price = Money.parse(price, :AUD) |> elem(1)
        quantity = String.to_integer(quantity)
        Map.merge(params, %{"total" => Money.multiply(price, quantity)})
      _ -> params
    end

    struct
    |> cast(derived_params, [:price, :quantity, :total, :product_id])
    |> validate_required([:price, :quantity, :total, :product_id])
  end
end
