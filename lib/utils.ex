defmodule Dinero.Utils do
  # 2568.7 * 100 must be 256870 and not 256869.9999...
  def convert_currency_to_coins(value) when is_float(value) do
    list =
      Float.to_string(value)
      |> String.split(".")

    first =
      List.first(list)
      |> String.to_integer()
      |> Kernel.*(100)

    last = List.last(list)

    if String.length(last) == 1 do
      first + String.to_integer(last) * 10
    else
      first +
        (String.slice(last, 0, 2)
         |> String.to_integer())
    end
  end

  def convert_currency_to_coins(value) when is_integer(value) do
    value * 100
  end
end
