defmodule PriceCrawler.ProductTest do
  use PriceCrawler.ModelCase

  alias PriceCrawler.Product

  @valid_attrs %{name: "some content", search_key: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Product.changeset(%Product{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Product.changeset(%Product{}, @invalid_attrs)
    refute changeset.valid?
  end
end
