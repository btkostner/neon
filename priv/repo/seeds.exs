# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Neon.Repo.insert!(%Neon.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

amex_market = Neon.Repo.insert!(%Neon.Stock.Market{
  abbreviation: "AMEX",
  name: "American Stock Exchange"
})

bats_market = Neon.Repo.insert!(%Neon.Stock.Market{
  abbreviation: "BATS",
  name: "Better Alternative Trading System"
})

nyse_market = Neon.Repo.insert!(%Neon.Stock.Market{
  abbreviation: "NYSE",
  name: "New York Stock Exchange"
})

nasdaq_market = Neon.Repo.insert!(%Neon.Stock.Market{
  abbreviation: "NASDAQ",
  name: "Nasdaq Stock Market"
})

nysearca_market = Neon.Repo.insert!(%Neon.Stock.Market{
  abbreviation: "NYSEARCA"
})

amzn_symbol = Neon.Repo.insert!(%Neon.Stock.Symbol{
  symbol: "AMZN",
  name: "Amazon.com, Inc.",
  currency: "USD",
  market_id: nasdaq_market.id
})

unh_symbol = Neon.Repo.insert!(%Neon.Stock.Symbol{
  symbol: "UNH",
  name: "UnitedHealth Group Inc",
  currency: "USD",
  market_id: nyse_market.id
})

ntsy_symbol = Neon.Repo.insert!(%Neon.Stock.Symbol{
  symbol: "NTSY",
  name: "Etsy Inc",
  currency: "USD",
  market_id: nasdaq_market.id
})
