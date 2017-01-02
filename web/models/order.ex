import EctoEnum
defenum OrderStatusEnum, placed: 0, purchased: 1, shipping: 2, closed: 3

defmodule PriceCrawler.Order do
  use PriceCrawler.Web, :model

  schema "orders" do
    field :customer, :string
    field :status, OrderStatusEnum
    field :shipping_vendor, :string
    field :shipping_number, :string
    field :cost, Money.Ecto.Type
    field :revenue, Money.Ecto.Type
    field :profit, Money.Ecto.Type

    has_many :items, PriceCrawler.Item, on_delete: :delete_all

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    derived_params = case params do
      %{"revenue" => revenue, "cost" => cost} ->
        revenue = Money.parse(revenue, :AUD) |> elem(1)
        cost = Money.parse(cost, :AUD) |> elem(1)
        Map.merge(params, %{"profit" => Money.subtract(revenue, cost)})
      _ -> params
    end

    struct
    |> Ecto.Changeset.cast(derived_params, [:customer, :status, :shipping_vendor, :shipping_number, :cost, :revenue, :profit])
    |> validate_required([:customer, :status, :shipping_vendor, :shipping_number, :cost, :revenue, :profit])
  end
end
