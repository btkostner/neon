defmodule NeonWeb.Accounts.UserSettingsView do
  use NeonWeb, :view

  def two_factor_enabled?(user) do
    user.two_factor_seed != nil
  end

  def two_factor_url(user, seed) do
    "otpauth://totp/#{user.email}?secret=#{seed}&issuer=Neon"
  end

  def two_factor_qr_code(user, seed) do
    user
    |> two_factor_url(seed)
    |> EQRCode.encode()
    |> EQRCode.svg(viewbox: true)
  end
end
