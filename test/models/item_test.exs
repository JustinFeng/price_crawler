defmodule PriceCrawler.ItemTest do
  use PriceCrawler.ModelCase

  alias PriceCrawler.Item

  @valid_attrs %{price: 42, quantity: 42, total: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Item.changeset(%Item{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Item.changeset(%Item{}, @invalid_attrs)
    refute changeset.valid?
  end
end
