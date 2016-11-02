import EctoEnum
defenum PriceTypeEnum, auto: 0, manual: 1

defmodule PriceCrawler.Price do
  use PriceCrawler.Web, :model

  schema "prices" do
    field :price, Money.Ecto.Type
    field :type, PriceTypeEnum
    belongs_to :product, PriceCrawler.Product

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> Ecto.Changeset.cast(params, [:price, :type])
    |> validate_required([:price, :type])
  end
end
