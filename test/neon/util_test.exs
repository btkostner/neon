defmodule Neon.UtilTest do
  use ExUnit.Case

  describe "modulo_date/3" do
    import Neon.Util

    test "rounds time 5 minutes before" do
      assert modulo_date(~U[2020-01-01 18:37:20.000Z]) == ~U[2020-01-01 18:35:00.000Z]
    end

    test "rounds time 5 minutes after" do
      assert modulo_date(~U[2020-01-01 18:37:20.000Z], :after) == ~U[2020-01-01 18:40:00.000Z]
    end
  end
end
