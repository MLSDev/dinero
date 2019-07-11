defmodule Dinero.SigilTest do
  use ExUnit.Case
  import Dinero.Sigil

  test "use sigil" do
    assert ~m[1_100.256] == Dinero.new(1100.25, :USD)
    assert ~m[1] == Dinero.new(1, :USD)
  end
end