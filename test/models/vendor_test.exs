defmodule PriceCrawler.VendorTest do
  use PriceCrawler.ModelCase

  alias PriceCrawler.Vendor

  @valid_attrs %{name: "some content", search_pattern: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Vendor.changeset(%Vendor{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Vendor.changeset(%Vendor{}, @invalid_attrs)
    refute changeset.valid?
  end
end
