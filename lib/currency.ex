defmodule Dinero.Currency do
  @moduledoc """
  Provides functions to work with supported currencies
  """
  @currencies [
    %{name: "United States dollar", code: :USD},
    %{name: "Euro", code: :EUR},
    %{name: "Zloty", code: :PLN},
    %{name: "Hryvnia", code: :UAH}
  ]

  @spec all() :: list
  @doc ~S"""
  Returns all supported currencies

  ## Example:

      iex> Dinero.Currency.all()
      [
        %{code: :USD, name: "United States dollar"},
        %{code: :EUR, name: "Euro"},
        %{code: :PLN, name: "Zloty"},
        %{code: :UAH, name: "Hryvnia"}
      ]
  
  """

  def all do
    @currencies
  end

  @spec get!(String.t() | atom) :: map | ArgumentError
  @doc ~S"""
  Returns a map with the name and code of the currency or raises ArgumentError if currency is not found

  ## Example:

      iex> Dinero.Currency.get!("USD")
      %{code: :USD, name: "United States dollar"}
      iex> Dinero.Currency.get!("RUR")
      ** (ArgumentError) currency RUR not found

  """
  def get!(currency) when is_atom(currency) do
    currency
    |> Atom.to_string()
    |> get!
  end

  def get!(currency) when is_binary(currency) do
    Enum.find(all(), fn map ->
      map[:code] |> Atom.to_string() |> String.downcase() == String.downcase(currency)
    end) ||
      raise(ArgumentError, "currency #{currency} not found")
  end
end
