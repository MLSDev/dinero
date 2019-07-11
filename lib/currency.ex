defmodule Dinero.Currency do
  @currencies [
    %{name: "United States dollar", code: :USD},
    %{name: "Euro", code: :EUR},
    %{name: "Zloty", code: :PLN},
    %{name: "Hryvnia", code: :UAH}
  ]

  def all do
    @currencies
  end

  def get!(currency) when is_atom(currency) do
    currency
    |>Atom.to_string
    |>get!
  end

  def get!(currency) when is_binary(currency) do
    Enum.find(all(), fn map -> map[:code] |> Atom.to_string |> String.downcase == String.downcase(currency) end) ||
      raise(ArgumentError, "currency #{currency} not found")
  end
end
