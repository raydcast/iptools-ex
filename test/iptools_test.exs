defmodule IptoolsTest do
  use ExUnit.Case
  doctest Iptools

  test "greets the world" do
    assert Iptools.hello() == :world
  end
end
