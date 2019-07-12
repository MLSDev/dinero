defmodule Dinero.Sigil do
  @moduledoc false

  @doc ~S"""
  Handles the sigil `~m` for Dinero

  ## Usage

    iex> import Dinero.Sigil
    iex> ~m[100.24]usd
    %Dinero{amount: 10024, currency: :USD}
  """

  defmacro sigil_m({:<<>>, _, [amount]}, [_ | _] = currency) do
    Macro.escape(Dinero.new(to_float(amount), List.to_atom(currency)))
  end

  defp to_float(amount) do
    normalized_str = String.replace(amount, "_", "")

    case Float.parse(normalized_str) do
      {num, _} -> num
      :error -> raise(ArgumentError, "#{normalized_str} can't be recognized as float value")
    end
  end
end
