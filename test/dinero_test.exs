defmodule DineroTest do
  use ExUnit.Case
  doctest Dinero

  test "new with integer amount" do
    assert Dinero.new(123, :USD) == %Dinero{amount: 12_300, currency: :USD}
  end

  test "new with float amount" do
    assert Dinero.new(0.02, :USD) == %Dinero{amount: 2, currency: :USD}
    assert Dinero.new(2568.7, :USD) == %Dinero{amount: 256_870, currency: :USD}
  end

  test "new with string currency" do
    assert Dinero.new(1235.32, "uah") == %Dinero{amount: 123_532, currency: :UAH}
  end

  test "new with invalid currency" do
    assert_raise ArgumentError, fn ->
      Dinero.new(123, :ABC)
    end
  end

  test "add the same currencies" do
    a = Dinero.new(123, :USD)
    b = Dinero.new(321, :USD)
    assert Dinero.add(a, b) == Dinero.new(444, :USD)
  end

  test "add different currencies" do
    a = Dinero.new(1, :USD)
    b = Dinero.new(2, :EUR)

    assert_raise FunctionClauseError, fn ->
      Dinero.add(a, b)
    end
  end

  test "subtract the same currencies" do
    a = Dinero.new(100, :USD)
    b = Dinero.new(20, :USD)
    assert Dinero.subtract(a, b) == Dinero.new(80, :USD)
  end

  test "subtract different currencies" do
    a = Dinero.new(100, :USD)
    b = Dinero.new(20, :EUR)

    assert_raise FunctionClauseError, fn ->
      Dinero.subtract(a, b)
    end
  end

  test "multiply integer" do
    a = Dinero.new(100, :USD)
    b = 5
    assert Dinero.multiply(a, b) == Dinero.new(500, :USD)
  end

  test "multiply round float" do
    d1 = Dinero.new(100, :USD)
    assert Dinero.multiply(d1, 0.05, true) == Dinero.new(5, :USD)
    assert Dinero.multiply(d1, 1.005, true) == Dinero.new(100.5, :USD)
    assert Dinero.multiply(d1, 1.5, true) == Dinero.new(150, :USD)

    d2 = Dinero.new(0.15, :USD)
    assert Dinero.multiply(d2, 1.05, true) == Dinero.new(0.16, :USD)

    assert Dinero.multiply(Dinero.new(8.93, :USD), 121.75, true) == Dinero.new(1087.23, :USD)
    assert Dinero.multiply(Dinero.new(8.93, :USD), 161.75, true) == Dinero.new(1444.43, :USD)
    assert Dinero.multiply(Dinero.new(17.26, :USD), 125.99, true) == Dinero.new(2174.59, :USD)
  end

  test "multiply trunc float" do
    a1 = Dinero.new(100, :USD)
    a2 = Dinero.new(0.15, :USD)
    assert Dinero.multiply(a1, 1.005) == Dinero.new(100.49, :USD)
    assert Dinero.multiply(a2, 1.05) == Dinero.new(0.157, :USD)

    assert Dinero.multiply(Dinero.new(8.93, :USD), 121.75) == Dinero.new(1087.22, :USD)
    assert Dinero.multiply(Dinero.new(8.93, :USD), 161.75) == Dinero.new(1444.42, :USD)
    assert Dinero.multiply(Dinero.new(17.26, :USD), 125.99) == Dinero.new(2174.58, :USD)
  end

  test "divide" do
    hours_per_month = 168

    assert Dinero.divide(Dinero.new(3000, :USD), hours_per_month) == Dinero.new(17.86, :USD)
    assert Dinero.divide(Dinero.new(1500, :USD), hours_per_month) == Dinero.new(8.93, :USD)
    assert Dinero.divide(Dinero.new(2500, :USD), hours_per_month) == Dinero.new(14.88, :USD)
  end

  test "exchange different currencies" do
    source = Dinero.new(100.34, :USD)
    rate = 25.6
    target = :UAH

    assert Dinero.convert(source, target, rate) == Dinero.new(2568.7, :UAH)
  end

  test "the same currencies" do
    source = Dinero.new(100, :USD)
    rate = 123
    target = :USD

    assert_raise ArgumentError, fn ->
      Dinero.convert(source, target, rate)
    end
  end
end
