defmodule NewsUtilTest do
  use ExUnit.Case
  doctest NewsUtil

  test "greets the world" do
    assert NewsUtil.hello() == :world
  end
end
