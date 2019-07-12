defmodule Dinero.Ecto.MoneyWithCurrency.Test do
  use ExUnit.Case

  alias Dinero.Ecto.MoneyWithCurrency

  doctest MoneyWithCurrency

  test "type" do
    assert MoneyWithCurrency.type() == :money_with_currency
  end

  test "dump valid" do
    a = Dinero.new(100, :USD)
    b = Dinero.new(234, :UAH)
    assert MoneyWithCurrency.dump(a) == {:ok, {10_000, "USD"}}
    assert MoneyWithCurrency.dump(b) == {:ok, {23_400, "UAH"}}
  end

  test "dump invalid" do
    assert MoneyWithCurrency.dump("invalid data") == :error
  end

  test "load valid" do
    a = Dinero.new(100, :USD)
    b = Dinero.new(234.43, :UAH)
    assert MoneyWithCurrency.load({10_000, "USD"}) == {:ok, a}
    assert MoneyWithCurrency.load({23_443, "UAH"}) == {:ok, b}
  end

  test "load invalid" do
    assert MoneyWithCurrency.load("invalid data") == :error
  end

  test "cast tuple" do
    a = Dinero.new(100, :USD)
    b = Dinero.new(1245.34, :UAH)
    assert MoneyWithCurrency.cast({10_000, :USD}) == {:ok, a}
    assert MoneyWithCurrency.cast({124_534, :UAH}) == {:ok, b}
  end

  test "cast map" do
  end

  test "invalid data" do
    assert MoneyWithCurrency.cast("invalid data") == :error
  end
end
