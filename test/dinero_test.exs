defmodule DineroTest do
  use ExUnit.Case
  doctest Dinero

  test "new with integer amount" do
    assert Dinero.new(123, :usd) == %Dinero{amount: 12_300, currency: :usd}
  end

  test "new with float amount" do
    assert Dinero.new(0.02, :usd) == %Dinero{amount: 2, currency: :usd}
  end

  test "add the same currencies" do
    a = Dinero.new(123, :usd)
    b = Dinero.new(321, :usd)
    assert Dinero.add(a, b) == Dinero.new(44_400, :usd)
  end

  test "add different currencies" do
    a = Dinero.new(1, :usd)
    b = Dinero.new(2, :eur)

    assert_raise FunctionClauseError, fn ->
      Dinero.add(a, b)
    end
  end

  test "add an int value to an existing currency" do
    a = Dinero.new(123, :usd)
    b = 100
    assert Dinero.add(a, b) == Dinero.new(22_300, :usd)
  end

  test "add a float value to an existing currency" do
    a = Dinero.new(123, :usd)
    b = 0.011231232
    assert Dinero.add(a, b) == Dinero.new(12_301, :usd)
  end

  test "subtract the same currencies" do
    a = Dinero.new(100, :usd)
    b = Dinero.new(20, :usd)
    assert Dinero.subtract(a, b) == Dinero.new(8_000, :usd)
  end

  test "subtract different currencies" do
    a = Dinero.new(100, :usd)
    b = Dinero.new(20, :eur)

    assert_raise FunctionClauseError, fn ->
      Dinero.subtract(a, b)
    end
  end

  test "subtract an int value" do
    a = Dinero.new(100, :usd)
    b = 20
    assert Dinero.subtract(a, b) == Dinero.new(8_000, :usd)
  end

  test "subtract a float value" do
    a = Dinero.new(100, :usd)
    b = 0.02
    assert Dinero.subtract(a, b) == Dinero.new(9_998, :usd)
  end
end
