defmodule SazzchatTest do
  use ExUnit.Case
  doctest Sazzchat

  test "greets the world" do
    assert Sazzchat.hello() == :world
  end
end
