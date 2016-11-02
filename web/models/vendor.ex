defmodule PriceCrawler.Vendor do
  use PriceCrawler.Web, :model

  schema "vendors" do
    field :name, :string
    field :search_pattern, :string

    has_many :products, PriceCrawler.Product

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :search_pattern])
    |> validate_required([:name, :search_pattern])
  end
end
