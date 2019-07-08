defmodule DineroTest do
  use ExUnit.Case
  doctest Dinero

  test "greets the world" do
    assert Dinero.hello() == :world
  end
end
