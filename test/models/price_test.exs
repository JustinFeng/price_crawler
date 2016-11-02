defmodule PriceCrawler.PriceTest do
  use PriceCrawler.ModelCase

  alias PriceCrawler.Price

  @valid_attrs %{price: 42, type: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Price.changeset(%Price{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Price.changeset(%Price{}, @invalid_attrs)
    refute changeset.valid?
  end
end
