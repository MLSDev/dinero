defmodule Dinero do
  alias Dinero.Currency
  alias Dinero.Utils

  @enforce_keys [:amount, :currency]
  defstruct [:amount, :currency]

  def new(amount, currency) when (is_integer(amount) or is_float(amount)) and is_atom(currency) do
    %Dinero{
      amount: Utils.convert_currency_to_coins(amount),
      currency: get_currency_code(currency)
    }
  end

  def add(%Dinero{amount: a, currency: currency}, %Dinero{amount: b, currency: currency}) do
    %Dinero{amount: a + b, currency: get_currency_code(currency)}
  end

  def add(%Dinero{amount: a, currency: currency}, value)
      when is_integer(value) or is_float(value) do
    %Dinero{
      amount: a + Utils.convert_currency_to_coins(value),
      currency: get_currency_code(currency)
    }
  end

  def subtract(%Dinero{amount: a, currency: currency}, %Dinero{amount: b, currency: currency}) do
    %Dinero{amount: a - b, currency: get_currency_code(currency)}
  end

  def subtract(%Dinero{amount: a, currency: currency}, value)
      when is_integer(value) or is_float(value) do
    %Dinero{
      amount: a - Utils.convert_currency_to_coins(value),
      currency: get_currency_code(currency)
    }
  end

  def multiply(%Dinero{amount: a, currency: currency}, value) when is_integer(value) do
    %Dinero{amount: a * value, currency: get_currency_code(currency)}
  end

  def multiply_round(%Dinero{} = d, value) when is_integer(value) do
    multiply(d, value)
  end

  # 10000*1.005 = 10049.999999999998
  def multiply_round(%Dinero{amount: a, currency: currency}, value) when is_float(value) do
    %Dinero{amount: round(a * value), currency: get_currency_code(currency)}
  end

  def multiply_trunc(%Dinero{amount: a, currency: currency}, value) when is_float(value) do
    %Dinero{amount: trunc(a * value), currency: get_currency_code(currency)}
  end

  def multiply_trunc(%Dinero{} = d, value) when is_integer(value) do
    multiply(d, value)
  end

  def divide(%Dinero{amount: a, currency: currency}, value)
      when is_integer(value) or is_float(value) do
    %Dinero{amount: round(a / value), currency: get_currency_code(currency)}
  end

  def formatted_string(%Dinero{amount: a, currency: currency}) do
    "#{a / 100} #{currency}"
  end

  def float_amount(%Dinero{amount: a}) do
    a / 100
  end

  def convert(%Dinero{amount: a}, target, exchange_rate) do
    %Dinero{
      amount: trunc(a * round(exchange_rate * 100) / 100),
      currency: get_currency_code(target)
    }
  end

  defp get_currency_code(currency) do
    Currency.get!(currency).code
  end
end
