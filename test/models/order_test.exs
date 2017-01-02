defmodule PriceCrawler.OrderTest do
  use PriceCrawler.ModelCase

  alias PriceCrawler.Order

  @valid_attrs %{cost: 42, customer: "some content", profit: 42, revenue: 42, shipping_number: "some content", shipping_vendor: "some content", status: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Order.changeset(%Order{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Order.changeset(%Order{}, @invalid_attrs)
    refute changeset.valid?
  end
end
