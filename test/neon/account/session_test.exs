defmodule Neon.Account.SessionTest do
  use Neon.DataCase

  alias Neon.Account.Session

  test "valid?/1 returns false if manually flagged as expired" do
    session = insert(:account_session, expired: true)
    refute Session.valid?(session)
  end

  test "valid?/1 returns false if past expired date" do
    session = insert(:account_session, expired_at: ~U[2000-01-01 13:00:00Z])
    refute Session.valid?(session)
  end

  test "valid?/1 returns true if everything is set correctly" do
    session = insert(:account_session, expired: false, expired_at: ~U[2099-01-01 13:00:00Z])
    assert Session.valid?(session)
  end
end
