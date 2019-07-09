defmodule Dinero do
  alias Dinero.Currency

  @enforce_keys [:amount, :currency]
  defstruct [:amount, :currency]

  def new(amount, currency) when is_integer(amount) and is_atom(currency) do
    %Dinero{amount: amount * 100, currency: get_currency_code(currency)}
  end

  def new(amount, currency) when is_float(amount) and is_atom(currency) do
    %Dinero{amount: trunc(amount * 100), currency: get_currency_code(currency)}
  end

  def add(%Dinero{amount: a, currency: currency}, %Dinero{amount: b, currency: currency}) do
    %Dinero{amount: a + b, currency: get_currency_code(currency)}
  end

  def add(%Dinero{amount: a, currency: currency}, value) when is_integer(value) do
    %Dinero{amount: a + value * 100, currency: get_currency_code(currency)}
  end

  def add(%Dinero{amount: a, currency: currency}, value) when is_float(value) do
    %Dinero{amount: a + trunc(value * 100), currency: get_currency_code(currency)}
  end

  def subtract(%Dinero{amount: a, currency: currency}, %Dinero{amount: b, currency: currency}) do
    %Dinero{amount: a - b, currency: get_currency_code(currency)}
  end

  def subtract(%Dinero{amount: a, currency: currency}, value) when is_integer(value) do
    %Dinero{amount: a - value * 100, currency: get_currency_code(currency)}
  end

  def subtract(%Dinero{amount: a, currency: currency}, value) when is_float(value) do
    %Dinero{amount: a - trunc(value * 100), currency: get_currency_code(currency)}
  end

  def multiply(%Dinero{amount: a, currency: currency}, value) when is_integer(value) do
    %Dinero{amount: a * value, currency: get_currency_code(currency)}
  end

  def multiply(%Dinero{amount: a, currency: currency}, value) when is_float(value) do
    %Dinero{amount: trunc(a * value), currency: get_currency_code(currency)}
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

  defp get_currency_code(currency) do
    Currency.get!(currency).code
  end
end
