if Code.ensure_compiled?(Ecto.Type) do
  defmodule Dinero.Ecto.MoneyWithCurrency do
    @behaviour Ecto.Type

    def type, do: :money_with_currency

    def dump(%Dinero{amount: amount, currency: currency}) do
      {:ok, {amount, to_string(currency)}}
    end

    def dump(_), do: :error

    def load({amount, currency}) do
      {:ok, Dinero.new(amount / 100, currency)}
    end

    def load(_), do: :error

    def cast({amount, currency})
        when is_integer(amount) and (is_binary(currency) or is_atom(currency)) do
      {:ok, Dinero.new(amount / 100, currency)}
    end

    # def cast(%{"amount" => amount, "currency" => currency}) when is_integer(amount) and (is_binary(currency) or is_atom(currency)) do
    #  {:ok, Dinero.new(amount, currency)}
    # end

    def cast(_), do: :error
  end
end
