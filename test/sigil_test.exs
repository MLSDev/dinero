defmodule Dinero.SigilTest do
  use ExUnit.Case, async: true
  doctest Dinero.Sigil

  import Dinero.Sigil

  test "valid sigil" do
    assert ~m[1_100.256]uah == Dinero.new(1100.25, :UAH)
    assert ~m[1]USD == Dinero.new(1, :USD)
  end

  test "invalid sigil" do
    invalid_sigil = quote(do: ~m[shit]usd)
    assert %ArgumentError{} = catch_error(Code.eval_quoted(invalid_sigil))
  end

  test "default currency" do
    assert ~m[100] == Dinero.new(100, :USD)
  end
end
