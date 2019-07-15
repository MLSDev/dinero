defmodule Dinero.Utils do
  @moduledoc false
  # 2568.7 * 100 must be 256870 and not 256869.9999...
  def convert_currency_to_coins(value) when is_float(value) do
    list =
      value
      |> Float.to_string()
      |> String.split(".")

    first =
      list
      |> List.first()
      |> String.to_integer()
      |> Kernel.*(100)

    last = List.last(list)

    if String.length(last) == 1 do
      first + String.to_integer(last) * 10
    else
      last
      |> String.slice(0, 2)
      |> String.to_integer()
      |> Kernel.+(first)
    end
  end

  def convert_currency_to_coins(value) when is_integer(value) do
    value * 100
  end
end
