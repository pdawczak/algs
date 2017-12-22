defmodule QuickUnionUFTest do
  use ExUnit.Case, async: true

  alias QuickUnionUF

  test "initiates new..." do
    assert QuickUnionUF.new(2)
  end

  test "checks connectivity" do
    str = QuickUnionUF.new(2)

    assert QuickUnionUF.connected?(str, 1, 1)
    refute QuickUnionUF.connected?(str, 1, 2)
    refute QuickUnionUF.connected?(str, 1, 3)
    refute QuickUnionUF.connected?(str, 3, 4)
  end

  test "connects two entries" do
    str = QuickUnionUF.new(2)

    new_str = QuickUnionUF.union(str, 1, 2)

    assert QuickUnionUF.connected?(new_str, 1, 2)
  end
end
