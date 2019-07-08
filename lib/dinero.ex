defmodule Dinero do
  @enforce_keys [:amount, :currency]
  defstruct [:amount, :currency]

  def new(amount, currency) when is_integer(amount) and is_atom(currency) do
    %Dinero{amount: amount * 100, currency: currency}
  end

  def new(amount, currency) when is_float(amount) and is_atom(currency) do
    %Dinero{amount: trunc(amount * 100), currency: currency}
  end

  def add(%Dinero{amount: a, currency: currency}, %Dinero{amount: b, currency: currency}) do
    Dinero.new(a + b, currency)
  end

  def add(%Dinero{} = d, value) when is_integer(value) do
    Dinero.new(d.amount + value * 100, d.currency)
  end

  def add(%Dinero{} = d, value) when is_float(value) do
    Dinero.new(d.amount + trunc(value * 100), d.currency)
  end

  def subtract(%Dinero{amount: a, currency: currency}, %Dinero{amount: b, currency: currency}) do
    Dinero.new(a - b, currency)
  end

  def subtract(%Dinero{} = d, value) when is_integer(value) do
    Dinero.new(d.amount - value * 100, d.currency)
  end

  def subtract(%Dinero{} = d, value) when is_float(value) do
    Dinero.new(d.amount - trunc(value * 100), d.currency)
  end
end
