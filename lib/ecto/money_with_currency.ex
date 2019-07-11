if Code.ensure_compiled?(Ecto.Type) do
  defmodule Dinero.Ecto.MoneyWithCurrency do
    @behaviour Ecto.Type

    def type, do: :money_with_currency

    
  end
end