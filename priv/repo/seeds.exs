# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PriceCrawler.Repo.insert!(%PriceCrawler.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

PriceCrawler.Repo.delete_all PriceCrawler.User

PriceCrawler.User.changeset(%PriceCrawler.User{}, %{name: "Michelle", email: "mc@gmail.com", password: "password", password_confirmation: "password"})
|> PriceCrawler.Repo.insert!