defmodule NeonWeb.AccountHelpers do
  @moduledoc """
  Conveniences for user account functions.
  """

  use Phoenix.HTML

  @gravatar_domain "gravatar.com"

  @doc """
  Returns a friendly, human name for a user based on their set name field, or
  their email field as a fallback.
  """
  def friendly_name(user) do
    if user.name, do: user.name, else: user.email
  end

  @doc """
  Generates a gravatar url for a user's email address.
  """
  def gravatar(user, opts \\ []) do
    {secure, opts} =
      opts
      |> Keyword.merge(default: :retro, rating: :x)
      |> Keyword.pop(:secure, true)

    %URI{}
    |> gravatar_host(secure)
    |> gravatar_hash_email(user.email)
    |> gravatar_options(opts)
    |> to_string
  end

  defp gravatar_options(uri, []), do: %URI{uri | query: nil}
  defp gravatar_options(uri, opts), do: %URI{uri | query: URI.encode_query(opts)}

  defp gravatar_host(uri, true),
    do: %URI{uri | scheme: "https", host: "secure.#{@gravatar_domain}"}

  defp gravatar_host(uri, false), do: %URI{uri | scheme: "http", host: @gravatar_domain}

  defp gravatar_hash_email(uri, email) do
    hash = :crypto.hash(:md5, String.downcase(email)) |> Base.encode16(case: :lower)
    %URI{uri | path: "/avatar/#{hash}"}
  end
end
