defmodule Dinero.SigilTest do
  use ExUnit.Case
  doctest Dinero.Sigil

  import Dinero.Sigil

  test "use sigil" do
    assert ~m[1_100.256]uah == Dinero.new(1100.25, :UAH)
    assert ~m[1]USD == Dinero.new(1, :USD)
  end
end
