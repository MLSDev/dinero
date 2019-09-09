defmodule Dinero.Ecto.DineroWithCurrency.Test do
  use ExUnit.Case

  alias Dinero.Ecto.DineroWithCurrency

  doctest DineroWithCurrency

  test "type" do
    assert DineroWithCurrency.type() == :dinero_with_currency
  end

  test "dump valid" do
    a = Dinero.new(100, :USD)
    b = Dinero.new(234, :UAH)
    assert DineroWithCurrency.dump(a) == {:ok, {10_000, "USD"}}
    assert DineroWithCurrency.dump(b) == {:ok, {23_400, "UAH"}}
  end

  test "dump invalid" do
    assert DineroWithCurrency.dump("invalid data") == :error
  end

  test "load valid" do
    a = Dinero.new(100, :USD)
    b = Dinero.new(234.43, :UAH)
    assert DineroWithCurrency.load({10_000, "USD"}) == {:ok, a}
    assert DineroWithCurrency.load({23_443, "UAH"}) == {:ok, b}
  end

  test "load invalid" do
    assert DineroWithCurrency.load("invalid data") == :error
  end

  test "cast tuple" do
    a = Dinero.new(100, :USD)
    b = Dinero.new(1245.34, :UAH)
    assert DineroWithCurrency.cast({10_000, :USD}) == {:ok, a}
    assert DineroWithCurrency.cast({124_534, :UAH}) == {:ok, b}
  end

  test "cast struct" do
    a = Dinero.new(100, :USD)
    assert DineroWithCurrency.cast(a) == {:ok, a}
  end

  test "cast/1 String" do
    assert DineroWithCurrency.cast("1000") == {:ok, Dinero.new(1000, :USD)}
    assert DineroWithCurrency.cast("1234.56") == {:ok, Dinero.new(1234.56, :USD)}
    assert DineroWithCurrency.cast("1,234.56") == {:ok, Dinero.new(1234.56, :USD)}
  end

  test "cast/1 integer" do
    assert DineroWithCurrency.cast(1000) == {:ok, Dinero.new(1000, :USD)}
  end

  test "cast/1 float" do
    assert DineroWithCurrency.cast(10.00) == {:ok, Dinero.new(10, :USD)}
  end

  test "invalid data" do
    assert DineroWithCurrency.cast("invalid data") == :error
  end
end
