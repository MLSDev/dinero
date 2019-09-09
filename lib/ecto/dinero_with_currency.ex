if Code.ensure_compiled?(Ecto.Type) do
  defmodule Dinero.Ecto.DineroWithCurrency do
    @moduledoc """
    Provides a custom type for Ecto to save dinero's amount with currency in database

    ## Example

      1. Create custom Postrgres type
      
      ```
      def up do
        execute "CREATE TYPE public.dinero_with_currency AS (amount integer, currency char(3))"
      end
      
      def down do
        execute "DROP TYPE public.dinero_with_currency"
      end
      ```

      2. Add column to the table

      ```
      alter table (:some_table) do
        add :price, :dinero_with_currency
      end
      ```
      3. Add field to the schema
      ```
      schema "some_table" do
        field :price, Dinero.Ecto.DineroWithCurrency
      end
      ```
    """

    @behaviour Ecto.Type

    def type, do: :dinero_with_currency

    def dump(%Dinero{amount: amount, currency: currency}) do
      {:ok, {amount, to_string(currency)}}
    end

    def dump(_), do: :error

    def load({amount, currency}) do
      {:ok, Dinero.new(amount / 100, currency)}
    end

    def load(%{"amount" => amount, "currency" => currency}) do
      {:ok, Dinero.new(amount / 100, currency)}
    end

    def load(_), do: :error

    def cast({amount, currency})
        when is_integer(amount) and (is_binary(currency) or is_atom(currency)) do
      {:ok, Dinero.new(amount / 100, currency)}
    end

    def cast(amount) when is_binary(amount) do
      Dinero.parse(amount)
    end

    def cast(amount) when is_integer(amount) do
      {:ok, Dinero.new(amount)}
    end

    def cast(amount) when is_float(amount) do
      {:ok, Dinero.new(amount)}
    end

    def cast(%Dinero{} = dinero) do
      {:ok, dinero}
    end

    def cast(_), do: :error
  end
end
