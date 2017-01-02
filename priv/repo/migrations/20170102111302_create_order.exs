defmodule PriceCrawler.Repo.Migrations.CreateOrder do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :customer, :string
      add :status, :integer
      add :shipping_vendor, :string
      add :shipping_number, :string
      add :cost, :integer
      add :revenue, :integer
      add :profit, :integer

      timestamps()
    end

  end
end
