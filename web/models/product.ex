defmodule PriceCrawler.Product do
  use PriceCrawler.Web, :model

  schema "products" do
    field :name, :string
    field :search_key, :string
    belongs_to :vendor, PriceCrawler.Vendor

    has_many :prices, PriceCrawler.Price, on_delete: :delete_all

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :search_key, :vendor_id])
    |> validate_required([:name, :search_key, :vendor_id])
  end
end
