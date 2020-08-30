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

ivr_symbol = Neon.Repo.insert!(%Neon.Stock.Symbol{
  symbol: "IVR",
  name: "Invesco Mortgage Capital Inc",
  currency: "USD",
  market_id: nyse_market.id
})

nok_symbol = Neon.Repo.insert!(%Neon.Stock.Symbol{
  symbol: "NOK",
  name: "Nokia Oyj",
  currency: "USD",
  market_id: nyse_market.id
})

eric_symbol = Neon.Repo.insert!(%Neon.Stock.Symbol{
  symbol: "ERIC",
  name: "Ericsson",
  currency: "USD",
  market_id: nasdaq_market.id
})

vxx_symbol = Neon.Repo.insert!(%Neon.Stock.Symbol{
  symbol: "VXX",
  name: "Barclays PLC",
  currency: "USD",
  market_id: bats_market.id
})

lyft_symbol = Neon.Repo.insert!(%Neon.Stock.Symbol{
  symbol: "LYFT",
  name: "LYFT Inc",
  currency: "USD",
  market_id: nasdaq_market.id
})

dal_symbol = Neon.Repo.insert!(%Neon.Stock.Symbol{
  symbol: "DAL",
  name: "Delta Air Lines, Inc.",
  currency: "USD",
  market_id: nyse_market.id
})

work_symbol = Neon.Repo.insert!(%Neon.Stock.Symbol{
  symbol: "WORK",
  name: "Slack Technologies Inc",
  currency: "USD",
  market_id: nyse_market.id
})

uso_symbol = Neon.Repo.insert!(%Neon.Stock.Symbol{
  symbol: "USO",
  name: "United States Oil Fund LP",
  currency: "USD",
  market_id: nysearca_market.id
})

amrc_symbol = Neon.Repo.insert!(%Neon.Stock.Symbol{
  symbol: "AMRC",
  name: "Ameresco Inc",
  currency: "USD",
  market_id: nyse_market.id
})

gmab_symbol = Neon.Repo.insert!(%Neon.Stock.Symbol{
  symbol: "GMAB",
  name: "Genmab",
  currency: "USD",
  market_id: nasdaq_market.id
})

twtr_symbol = Neon.Repo.insert!(%Neon.Stock.Symbol{
  symbol: "TWTR",
  name: "Twitter Inc",
  currency: "USD",
  market_id: nyse_market.id
})

bip_symbol = Neon.Repo.insert!(%Neon.Stock.Symbol{
  symbol: "BIP",
  name: "Brookfield Infrastructure Partners",
  currency: "USD",
  market_id: nyse_market.id
})

bwxt_symbol = Neon.Repo.insert!(%Neon.Stock.Symbol{
  symbol: "BWXT",
  name: "BWX Technologies Inc",
  currency: "USD",
  market_id: nyse_market.id
})

yndx_symbol = Neon.Repo.insert!(%Neon.Stock.Symbol{
  symbol: "YNDX",
  name: "Yandex",
  currency: "USD",
  market_id: nasdaq_market.id
})

sne_symbol = Neon.Repo.insert!(%Neon.Stock.Symbol{
  symbol: "SNE",
  name: "Sony Corp",
  currency: "USD",
  market_id: nyse_market.id
})

schb_symbol = Neon.Repo.insert!(%Neon.Stock.Symbol{
  symbol: "SCHB",
  name: "Schwab",
  currency: "USD",
  market_id: nysearca_market.id
})

gliba_symbol = Neon.Repo.insert!(%Neon.Stock.Symbol{
  symbol: "GLIBA",
  name: "GCI Liberty Inc",
  currency: "USD",
  market_id: nasdaq_market.id
})

amd_symbol = Neon.Repo.insert!(%Neon.Stock.Symbol{
  symbol: "AMD",
  name: "Advanced Micro Devices",
  currency: "USD",
  market_id: nasdaq_market.id
})

bax_symbol = Neon.Repo.insert!(%Neon.Stock.Symbol{
  symbol: "BAX",
  name: "Baxter International Inc",
  currency: "USD",
  market_id: nyse_market.id
})

xpo_symbol = Neon.Repo.insert!(%Neon.Stock.Symbol{
  symbol: "XPO",
  name: "XPO Logistics Inc",
  currency: "USD",
  market_id: nyse_market.id
})

gwph_symbol = Neon.Repo.insert!(%Neon.Stock.Symbol{
  symbol: "GWPH",
  name: "GW Pharmaceuticals",
  currency: "USD",
  market_id: nasdaq_market.id
})

xsd_symbol = Neon.Repo.insert!(%Neon.Stock.Symbol{
  symbol: "XSD",
  name: "SPDR S&P Semiconductor",
  currency: "USD",
  market_id: nysearca_market.id
})

bynd_symbol = Neon.Repo.insert!(%Neon.Stock.Symbol{
  symbol: "BYND",
  name: "Beyond Meat Inc",
  currency: "USD",
  market_id: nasdaq_market.id
})

etsy_symbol = Neon.Repo.insert!(%Neon.Stock.Symbol{
  symbol: "NTSY",
  name: "Etsy Inc",
  currency: "USD",
  market_id: nasdaq_market.id
})

se_symbol = Neon.Repo.insert!(%Neon.Stock.Symbol{
  symbol: "SE",
  name: "Sea Ltd",
  currency: "USD",
  market_id: nyse_market.id
})

mmm_symbol = Neon.Repo.insert!(%Neon.Stock.Symbol{
  symbol: "MMM",
  name: "3M Co",
  currency: "USD",
  market_id: nyse_market.id
})

smh_symbol = Neon.Repo.insert!(%Neon.Stock.Symbol{
  symbol: "SMH",
  name: "VANECK VECTORS/SEMICONDUCTOR ETF",
  currency: "USD",
  market_id: nasdaq_market.id
})

gld_symbol = Neon.Repo.insert!(%Neon.Stock.Symbol{
  symbol: "GLD",
  name: "SPDR Gold Trust",
  currency: "USD",
  market_id: nysearca_market.id
})

lh_symbol = Neon.Repo.insert!(%Neon.Stock.Symbol{
  symbol: "LH",
  name: "Laboratory Corp. of America Holdings",
  currency: "USD",
  market_id: nyse_market.id
})

msft_symbol = Neon.Repo.insert!(%Neon.Stock.Symbol{
  symbol: "MSFT",
  name: "Microsoft Corporation",
  currency: "USD",
  market_id: nasdaq_market.id
})

fb_symbol = Neon.Repo.insert!(%Neon.Stock.Symbol{
  symbol: "FB",
  name: "Facebook, Inc. Common Stock",
  currency: "USD",
  market_id: nasdaq_market.id
})

qqq_symbol = Neon.Repo.insert!(%Neon.Stock.Symbol{
  symbol: "QQQ",
  name: "PowerShares QQQ Trust, Series 1",
  currency: "USD",
  market_id: nasdaq_market.id
})

coo_symbol = Neon.Repo.insert!(%Neon.Stock.Symbol{
  symbol: "COO",
  name: "Cooper Companies Inc",
  currency: "USD",
  market_id: nyse_market.id
})

unh_symbol = Neon.Repo.insert!(%Neon.Stock.Symbol{
  symbol: "UNH",
  name: "UnitedHealth Group Inc",
  currency: "USD",
  market_id: nyse_market.id
})

spy_symbol = Neon.Repo.insert!(%Neon.Stock.Symbol{
  symbol: "SPY",
  name: "SPDR S&P 500 ETF Trust",
  currency: "USD",
  market_id: nysearca_market.id
})

aapl_symbol = Neon.Repo.insert!(%Neon.Stock.Symbol{
  symbol: "AAPL",
  name: "Apple Inc.",
  currency: "USD",
  market_id: nasdaq_market.id
})

nvda_symbol = Neon.Repo.insert!(%Neon.Stock.Symbol{
  symbol: "NVDA",
  name: "NVIDIA Corporation",
  currency: "USD",
  market_id: nasdaq_market.id
})

nflx_symbol = Neon.Repo.insert!(%Neon.Stock.Symbol{
  symbol: "NFLX",
  name: "Netflix Inc",
  currency: "USD",
  market_id: nasdaq_market.id
})

bio_symbol = Neon.Repo.insert!(%Neon.Stock.Symbol{
  symbol: "BIO",
  name: "Bio-Rad Laboratories, Inc. Class A Common",
  currency: "USD",
  market_id: nyse_market.id
})

goog_symbol = Neon.Repo.insert!(%Neon.Stock.Symbol{
  symbol: "GOOG",
  name: "Alphabet Inc Class C",
  currency: "USD",
  market_id: nasdaq_market.id
})

tsla_symbol = Neon.Repo.insert!(%Neon.Stock.Symbol{
  symbol: "TSLA",
  name: "Tesla Inc",
  currency: "USD",
  market_id: nasdaq_market.id
})

amzn_symbol = Neon.Repo.insert!(%Neon.Stock.Symbol{
  symbol: "AMZN",
  name: "Amazon.com, Inc.",
  currency: "USD",
  market_id: nasdaq_market.id
})
