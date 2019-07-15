defmodule Dinero do
  alias Dinero.Currency
  alias Dinero.Utils

  @moduledoc """
  `Dinero` is a struct that provides methods for working with currencies

  ## Examples
  
      iex> d = Dinero.new(100, :USD)
      %Dinero{amount: 10000, currency: :USD}
      iex> Dinero.add(d, 200)
      %Dinero{amount: 30000, currency: :USD}

  **Note:** `Dinero` uses coins value for calculations. So when you
  create a new `Dinero` struct with 100 USD it automatically transforms this into 10000 cents
  """

  @enforce_keys [:amount, :currency]
  defstruct [:amount, :currency]

  @type t :: %__MODULE__{
          amount: integer,
          currency: atom
        }

  @spec new(integer | float, atom | String.t()) :: t
  @doc ~S"""
  Creates a new `Dinero` struct with provided currency.
  If currency is not supported, ArgumentError will be raised

  ## Examples

      iex> Dinero.new(100, :USD)
      %Dinero{amount: 10000, currency: :USD}
      iex> Dinero.new(100, :RUR)
      ** (ArgumentError) currency RUR not found
    
  """
  def new(amount, currency)
      when (is_integer(amount) or is_float(amount)) and (is_atom(currency) or is_binary(currency)) do
    %Dinero{
      amount: Utils.convert_currency_to_coins(amount),
      currency: get_currency_code(currency)
    }
  end

  @spec add(t, t | integer | float) :: t
  @doc ~S"""
  Adds two `Dinero` structs or `Dinero` and integer or float value.
  Both integer and float values will be converted to cents

  ## Examples

      iex> d1 = Dinero.new(100, :USD)
      %Dinero{amount: 10000, currency: :USD}
      iex> d2 = Dinero.new(20, :USD)
      %Dinero{amount: 2000, currency: :USD}
      iex> Dinero.add(d1, d2)
      %Dinero{amount: 12000, currency: :USD}
      iex> Dinero.add(d1, 10)
      %Dinero{amount: 11000, currency: :USD}
      iex> Dinero.add(d1, 0.05)
      %Dinero{amount: 10005, currency: :USD}
    
  """
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

  @spec add(t, t | integer | float) :: t
  @doc ~S"""
  Subtracts one `Dinero` from another or an integer/float (converted to cents) from a `Dinero`

  ## Examples

      iex> d1 = Dinero.new(100, :USD)
      %Dinero{amount: 10000, currency: :USD}
      iex> d2 = Dinero.new(20, :USD)
      %Dinero{amount: 2000, currency: :USD}
      iex> Dinero.subtract(d1, d2)
      %Dinero{amount: 8000, currency: :USD}
      iex> Dinero.subtract(d1, 10)
      %Dinero{amount: 9000, currency: :USD}
      iex> Dinero.subtract(d1, 10.24)
      %Dinero{amount: 8976, currency: :USD}
    
  """
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

  @spec multiply(t, integer | float, boolean) :: t
  @doc ~S"""
  Multiplies a `Dinero` by a value. If a multiplier is float you can pass the third boolean param to round up (true) or truncate (false, default) the result

  ## Examples

      iex> d = Dinero.new(120, :USD)
      %Dinero{amount: 12000, currency: :USD}
      iex> Dinero.multiply(d, 4)
      %Dinero{amount: 48000, currency: :USD}
      iex> d = Dinero.new(100, :USD)
      %Dinero{amount: 10000, currency: :USD}
      iex> Dinero.multiply(d, 1.005, true)
      %Dinero{amount: 10050, currency: :USD}
      iex> Dinero.multiply(d, 1.005)      
      %Dinero{amount: 10049, currency: :USD}
    
  """
  def multiply(%Dinero{amount: a, currency: currency}, value, round_up \\ false)
      when is_integer(value) or (is_float(value) and is_boolean(round_up)) do
    cond do
      is_integer(value) ->
        %Dinero{amount: a * value, currency: get_currency_code(currency)}

      is_float(value) && round_up ->
        %Dinero{amount: round(a * value), currency: get_currency_code(currency)}

      true ->
        %Dinero{amount: trunc(a * value), currency: get_currency_code(currency)}
    end
  end

  @spec divide(t, integer | float) :: t
  @doc ~S"""
  Divides `Dinero` by a value and rounds the result

  ## Examples

      iex> d = Dinero.new(100.24, :USD)
      %Dinero{amount: 10024, currency: :USD}
      iex> Dinero.divide(d, 3)
      %Dinero{amount: 3341, currency: :USD}
      iex> Dinero.divide(d, 5)
      %Dinero{amount: 2005, currency: :USD}
    
  """
  def divide(%Dinero{amount: a, currency: currency}, value)
      when is_integer(value) or is_float(value) do
    %Dinero{amount: round(a / value), currency: get_currency_code(currency)}
  end

  @spec convert(t, atom | String.t(), float) :: t
  @doc ~S"""
  Converts value of `Dinero` to target currency using exchange_rate

  ## Examples

      iex> d = Dinero.new(100, :USD)
      %Dinero{amount: 10000, currency: :USD}
      iex> Dinero.convert(d, :UAH, 26.2)
      %Dinero{amount: 262000, currency: :UAH}
      iex> Dinero.convert(d, :USD, 26.2)
      ** (ArgumentError) target currency must be different from source currency
    
  """
  def convert(%Dinero{} = d, target, exchange_rate) do
    if get_currency_code(d.currency) != get_currency_code(target) do
      %Dinero{
        amount: trunc(d.amount * round(exchange_rate * 100) / 100),
        currency: get_currency_code(target)
      }
    else
      raise(ArgumentError, "target currency must be different from source currency")
    end
  end

  defp get_currency_code(currency) do
    Currency.get!(currency).code
  end
end
