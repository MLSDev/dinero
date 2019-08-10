defmodule Dinero.Sigil do
  @moduledoc """
  Provides sigil to create `Dinero` struct
  """

  @doc ~S"""
  Handles the sigil `~m` for Dinero

  ## Usage

      iex> import Dinero.Sigil
      iex> ~m[100.24]uah
      %Dinero{amount: 10024, currency: :UAH}
      iex> ~m[100]
      %Dinero{amount: 10000, currency: :USD}

  """

  defmacro sigil_m({:<<>>, _, [amount]}, [_ | _] = currency) do
    Macro.escape(Dinero.new(to_float(amount), List.to_atom(currency)))
  end

  defmacro sigil_m({:<<>>, _, [amount]}, []) do
    Macro.escape(Dinero.new(to_float(amount), :USD))
  end

  defp to_float(amount) do
    normalized_str = String.replace(amount, "_", "")

    case Float.parse(normalized_str) do
      {num, _} -> num
      :error -> raise(ArgumentError, "#{normalized_str} can't be recognized as float value")
    end
  end
end
