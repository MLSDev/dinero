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

  def get!(currency) do
    Enum.find(all(), fn map -> map[:code] == currency end) ||
      raise(ArgumentError, "currency #{currency} not found")
  end
end
