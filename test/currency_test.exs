defmodule CurrencyTest do
  use ExUnit.Case
  alias Dinero.Currency

  test "all" do
    assert Currency.all() == [
             %{name: "United States dollar", code: :USD},
             %{name: "Euro", code: :EUR},
             %{name: "Zloty", code: :PLN},
             %{name: "Hryvnia", code: :UAH}
           ]
  end

  test "get!" do
    assert Currency.get!(:USD) == %{name: "United States dollar", code: :USD}
    assert Currency.get!(:usd) == %{name: "United States dollar", code: :USD}
    assert Currency.get!(:Usd) == %{name: "United States dollar", code: :USD}
    assert Currency.get!("usd") == %{name: "United States dollar", code: :USD}
    assert_raise ArgumentError, fn -> Currency.get!(:ABC) end
  end
end
