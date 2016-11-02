defmodule PriceCrawler.Repo.Migrations.CreateVendor do
  use Ecto.Migration

  def change do
    create table(:vendors) do
      add :name, :string
      add :search_pattern, :string

      timestamps()
    end

  end
end
