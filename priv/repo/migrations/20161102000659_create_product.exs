defmodule PriceCrawler.Repo.Migrations.CreateProduct do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string
      add :search_key, :string
      add :vendor_id, references(:vendors, on_delete: :nothing)

      timestamps()
    end
    create index(:products, [:vendor_id])

  end
end
