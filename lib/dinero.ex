defmodule Dinero do
  alias Dinero.Currency
  alias Dinero.Utils

  @moduledoc """
  `Dinero` is a struct that provides methods for working with currencies

  ## Examples

      iex> d1 = Dinero.new(100, :USD)
      %Dinero{amount: 10000, currency: :USD}
      iex> d2 = Dinero.new(200, :USD)
      %Dinero{amount: 20000, currency: :USD}
      iex> Dinero.add(d1, d2)
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
      iex> Dinero.new(1.0e4, :USD) 
      %Dinero{amount: 1000000, currency: :USD}
      iex> Dinero.new(100, :RUR)
      ** (ArgumentError) currency RUR not found
    
  """
  def new(amount, currency \\ :USD)
      when (is_integer(amount) or is_float(amount)) and (is_atom(currency) or is_binary(currency)) do
    %Dinero{
      amount: Utils.convert_currency_to_coins(amount),
      currency: get_currency_code(currency)
    }
  end

  @spec add(t, t) :: t
  @doc ~S"""
  Adds two `Dinero` structs

  ## Examples

      iex> d1 = Dinero.new(100, :USD)
      %Dinero{amount: 10000, currency: :USD}
      iex> d2 = Dinero.new(20, :USD)
      %Dinero{amount: 2000, currency: :USD}
      iex> Dinero.add(d1, d2)
      %Dinero{amount: 12000, currency: :USD}
    
  """
  def add(%Dinero{amount: a, currency: currency}, %Dinero{amount: b, currency: currency}) do
    %Dinero{amount: a + b, currency: get_currency_code(currency)}
  end

  @spec subtract(t, t) :: t
  @doc ~S"""
  Subtracts one `Dinero` from another

  ## Examples

      iex> d1 = Dinero.new(100, :USD)
      %Dinero{amount: 10000, currency: :USD}
      iex> d2 = Dinero.new(20, :USD)
      %Dinero{amount: 2000, currency: :USD}
      iex> Dinero.subtract(d1, d2)
      %Dinero{amount: 8000, currency: :USD}

  """
  def subtract(%Dinero{amount: a, currency: currency}, %Dinero{amount: b, currency: currency}) do
    %Dinero{amount: a - b, currency: get_currency_code(currency)}
  end

  @spec multiply(t, integer | float) :: t
  @doc ~S"""
  Multiplies a `Dinero` by a value and truncates the result

  ## Examples

      iex> d = Dinero.new(120, :USD)
      %Dinero{amount: 12000, currency: :USD}
      iex> Dinero.multiply(d, 4)
      %Dinero{amount: 48000, currency: :USD}
      iex> d = Dinero.new(100, :USD)
      %Dinero{amount: 10000, currency: :USD}
      iex> Dinero.multiply(d, 1.005)      
      %Dinero{amount: 10049, currency: :USD}

  """
  def multiply(%Dinero{amount: a, currency: currency}, value)
      when is_integer(value) or is_float(value) do
    %Dinero{amount: trunc(a * value), currency: get_currency_code(currency)}
  end

  @spec multiply(t, integer | float, atom) :: t
  @doc ~S"""
  Multiplies a `Dinero` by a value and rounds up the result

  ## Examples

      iex> d = Dinero.new(100, :USD)
      %Dinero{amount: 10000, currency: :USD}
      iex> Dinero.multiply(d, 1.005, :round_up)
      %Dinero{amount: 10050, currency: :USD}

  """
  def multiply(%Dinero{amount: a, currency: currency}, value, round_up)
      when (is_integer(value) or is_float(value)) and is_atom(round_up) do
    %Dinero{amount: round(a * value), currency: get_currency_code(currency)}
  end

  @spec divide(t, integer | float) :: t
  @doc ~S"""
  Divides `Dinero` by a value and truncates the result

  ## Examples

      iex> d = Dinero.new(100.24, :USD)
      %Dinero{amount: 10024, currency: :USD}
      iex> Dinero.divide(d, 3)
      %Dinero{amount: 3341, currency: :USD}
      iex> Dinero.divide(d, 5)
      %Dinero{amount: 2004, currency: :USD}

  """
  def divide(%Dinero{amount: a, currency: currency}, value)
      when is_integer(value) or is_float(value) do
    %Dinero{amount: trunc(a / value), currency: get_currency_code(currency)}
  end

  @spec divide(t, integer | float, atom) :: t
  @doc ~S"""
  Divides `Dinero` by a value and rounds up the result

  ## Examples

      iex> d = Dinero.new(100.24, :USD)
      %Dinero{amount: 10024, currency: :USD}
      iex> Dinero.divide(d, 3, :round_up)
      %Dinero{amount: 3341, currency: :USD}
      iex> Dinero.divide(d, 5, :round_up)
      %Dinero{amount: 2005, currency: :USD}

  """
  def divide(%Dinero{amount: a, currency: currency}, value, round_up)
      when (is_integer(value) or is_float(value)) and is_atom(round_up) do
    %Dinero{amount: round(a / value), currency: get_currency_code(currency)}
  end

  @spec convert(t, atom | String.t(), float) :: t
  @doc ~S"""
  Converts value of `Dinero` to target currency using exchange_rate and truncates the result

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
        amount: trunc(d.amount * exchange_rate),
        currency: get_currency_code(target)
      }
    else
      raise(ArgumentError, "target currency must be different from source currency")
    end
  end

  @spec parse!(String.t(), atom) :: t
  @doc ~S"""
  Creates `Dinero` from String that represents integer or float. If a string can't be parsed ArgumentError is raised
  If the second param is not provided it uses USD as default currency

  ## Examples

    iex> Dinero.parse!("123.23")
    %Dinero{amount: 12323, currency: :USD}
    iex> Dinero.parse!("112")
    %Dinero{amount: 11200, currency: :USD}
    iex> Dinero.parse!("2", :UAH)
    %Dinero{amount: 200, currency: :UAH}
    iex> Dinero.parse!("100.00")  
    %Dinero{amount: 10000, currency: :USD}
    iex> Dinero.parse!("invalid string")
    ** (ArgumentError) invalid string. it must contain string that represents integer or float

  """
  def parse!(amount, currency \\ :USD) when is_binary(amount) do
    case parse(amount, currency) do
      {:ok, %Dinero{} = dinero} ->
        dinero

      :error ->
        raise(
          ArgumentError,
          "invalid string. it must contain string that represents integer or float"
        )
    end
  end

  @spec parse(String.t(), atom) :: {:ok, t} | :error
  @doc """
  Same as `parse!/2`, but returns either `{:ok, %Dinero{}}` or `:error`

  ## Examples

    iex> Dinero.parse("123.23")
    {:ok, %Dinero{amount: 12323, currency: :USD}}
    iex> Dinero.parse("invalid string")
    :error

  """
  def parse(amount, currency \\ :USD) when is_binary(amount) do
    amount = String.replace(amount, ~r/[_,]/, "")

    amount =
      if String.contains?(amount, ".") do
        Float.parse(amount)
      else
        Integer.parse(amount)
      end

    case amount do
      {a, _} -> {:ok, Dinero.new(a, currency)}
      :error -> :error
    end
  end

  @spec equals?(t, t) :: boolean
  @doc """
  Compares two Dinero structs.

  Returns `true`, if amounts and currencies match. Otherwise returns `false`.
  """
  def equals?(%Dinero{} = a, %Dinero{} = b) do
    a.amount == b.amount && get_currency_code(a.currency) == get_currency_code(b.currency)
  end

  @spec zero?(t) :: boolean
  @doc """
  Returns `true`, if amount is zero.
  """
  def zero?(%Dinero{} = a), do: a.amount == 0

  defp get_currency_code(currency) do
    Currency.get!(currency).code
  end

  @spec to_float(t) :: float
  @doc """
  Returns float representation of Dinero.

  ## Examples

      iex> import Dinero.Sigil
      iex> Dinero.to_float(~m[100.14]USD)
      100.14
      iex> Dinero.to_float(~m[0.01]uah)
      0.01

  """
  def to_float(%Dinero{amount: amount}) do
    amount / 100.0
  end
end

defimpl String.Chars, for: Dinero do
  def to_string(dinero) do
    :erlang.float_to_binary(dinero.amount / 100, decimals: 2)
  end
end

if Code.ensure_compiled?(Jason.Encoder) do
  require Protocol
  Protocol.derive(Jason.Encoder, Dinero, only: [:amount, :currency])
end
