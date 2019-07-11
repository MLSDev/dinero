defmodule Dinero.Sigil do
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
