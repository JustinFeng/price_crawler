defmodule PriceCrawler.Repo.Migrations.CreateItem do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :price, :integer
      add :quantity, :integer
      add :total, :integer
      add :order_id, references(:orders, on_delete: :nothing)
      add :product_id, references(:products, on_delete: :nothing)

      timestamps()
    end
    create index(:items, [:order_id])
    create index(:items, [:product_id])

  end
end
