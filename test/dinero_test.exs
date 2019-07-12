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

  test "add an int value to an existing currency" do
    a = Dinero.new(123, :USD)
    b = 100
    assert Dinero.add(a, b) == Dinero.new(223, :USD)
  end

  test "add a float value to an existing currency" do
    a = Dinero.new(123, :USD)
    b = 0.011231232
    assert Dinero.add(a, b) == Dinero.new(123.01, :USD)
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

  test "subtract an int value" do
    a = Dinero.new(100, :USD)
    b = 20
    assert Dinero.subtract(a, b) == Dinero.new(80, :USD)
  end

  test "subtract a float value" do
    a = Dinero.new(100, :USD)
    b = 0.02
    assert Dinero.subtract(a, b) == Dinero.new(99.98, :USD)
  end

  test "multiply integer" do
    a = Dinero.new(100, :USD)
    b = 5
    assert Dinero.multiply(a, b) == Dinero.new(500, :USD)
  end

  test "multiply round float" do
    a = Dinero.new(100, :USD)
    assert Dinero.multiply_round(a, 0.05) == Dinero.new(5, :USD)
    assert Dinero.multiply_round(a, 1.005) == Dinero.new(100.5, :USD)
    assert Dinero.multiply_round(a, 1.5) == Dinero.new(150, :USD)

    a2 = Dinero.new(0.15, :USD)
    assert Dinero.multiply_round(a2, 1.05) == Dinero.new(0.16, :USD)
  end

  test "multiply trunc float" do
    a1 = Dinero.new(100, :USD)
    a2 = Dinero.new(0.15, :USD)
    assert Dinero.multiply_trunc(a1, 1.005) == Dinero.new(100.49, :USD)
    assert Dinero.multiply_trunc(a2, 1.05) == Dinero.new(0.157, :USD)
  end

  test "divide" do
    a = Dinero.new(3000, :USD)
    b = 168
    assert Dinero.divide(a, b) == Dinero.new(17.86, :USD)
  end

  test "formatted string" do
    a = Dinero.new(123.3456565, :USD)
    assert Dinero.formatted_string(a) == "123.34 USD"
  end

  test "float_amount" do
    rate = Dinero.new(14.05, :USD)
    assert Dinero.float_amount(rate) == 14.05

    rate = Dinero.new(1000, :USD)
    assert Dinero.float_amount(rate) == 1000
  end

  test "exchange" do
    source = Dinero.new(100.34, :USD)
    rate = 25.6
    target = :UAH

    assert Dinero.convert(source, target, rate) == Dinero.new(2568.7, :UAH)
  end
end
