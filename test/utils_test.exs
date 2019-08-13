defmodule UtilsTest do
  use ExUnit.Case
  alias Dinero.Utils

  test "convert_currency_to_coins for integer" do
    assert Utils.convert_currency_to_coins(12_356) == 1_235_600
  end

  test "convert_currency_to_coins for float" do
    assert Utils.convert_currency_to_coins(2568.7) == 256_870
    assert Utils.convert_currency_to_coins(0.02) == 2
    assert Utils.convert_currency_to_coins(0.0002) == 0
    assert Utils.convert_currency_to_coins(1.0e3) == 100000
  end
end
