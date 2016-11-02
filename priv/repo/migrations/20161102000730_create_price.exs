defmodule PriceCrawler.Repo.Migrations.CreatePrice do
  use Ecto.Migration

  def change do
    create table(:prices) do
      add :price, :integer
      add :type, :integer
      add :product_id, references(:products, on_delete: :nothing)

      timestamps()
    end
    create index(:prices, [:product_id])

  end
end
