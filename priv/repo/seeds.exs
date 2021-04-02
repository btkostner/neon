alias Neon.Market.Exchange
alias Neon.Repo

Repo.insert!(%Exchange{
  abbreviation: "AMEX",
  name: "American Stock Exchange"
})

Repo.insert!(%Exchange{
  abbreviation: "ARCA",
  name: "Archipelago Exchange"
})

Repo.insert!(%Exchange{
  abbreviation: "BATS",
  name: "Bats Global Markets"
})

Repo.insert!(%Exchange{
  abbreviation: "NYSE",
  name: "New York Stock Exchange"
})

Repo.insert!(%Exchange{
  abbreviation: "NASDAQ",
  name: "Nasdaq Stock Market"
})

Repo.insert!(%Exchange{
  abbreviation: "NYSEARCA",
  name: "NYSE Arca"
})
