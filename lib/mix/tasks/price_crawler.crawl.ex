defmodule Mix.Tasks.PriceCrawler.Crawl do
  use Mix.Task

  import Mix.Ecto
  import Ecto.Query, only: [from: 2]

  alias PriceCrawler.Repo

  @shortdoc "Crawl prices"

  def run(_args) do
  	HTTPoison.start
  	ensure_started(Repo, [])

    Repo.all(PriceCrawler.Product)
    |> Enum.each(fn(product) ->
      Repo.all(PriceCrawler.Vendor)
      |> Enum.find(&(&1.id == product.vendor_id))
      |> case do
        %PriceCrawler.Vendor{search_pattern: search_pattern} ->
          new_money = fetch_price(search_pattern, product.search_key)
          new_price = new_money.amount
          Repo.one(from x in PriceCrawler.Price, order_by: [desc: x.id], where: x.product_id == ^product.id, limit: 1)
          |> case do
            %PriceCrawler.Price{price: %Money{amount: amount}} when amount == new_price ->
              IO.puts "Price stay the same!"
            _ ->
              product
              |> Ecto.build_assoc(:prices)
              |> PriceCrawler.Price.changeset(%{price: new_money, type: "auto"})
              |> Repo.insert
          end
      end
    end)
  end

  defp fetch_price search_pattern, search_key do
  	search_pattern
  	|> String.replace("$SEARCH_KEY$", search_key)
  	|> URI.encode
  	|> HTTPoison.get
  	|> case do
	    {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
	      body
	      |> Floki.find(".Price")
	      |> List.first 
	      |> Floki.text
	      |> String.trim
        |> Money.parse
        |> case do
          {:ok, money} ->
            money
          {:error, _} ->
            IO.puts "Wrong price format"
        end
	    {:ok, %HTTPoison.Response{status_code: 404}} ->
	      IO.puts "404 - #{search_pattern} - #{search_key}"
	    {:error, %HTTPoison.Error{reason: reason}} ->
	      IO.inspect reason
    end
  end
end