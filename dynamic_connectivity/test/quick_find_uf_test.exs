defmodule QuickFindUFTest do
  use ExUnit.Case

  alias QuickFindUF

  test "initiates new..." do
    assert QuickFindUF.new(2)
  end

  test "checks connectivity" do
    str = QuickFindUF.new(2)

    assert QuickFindUF.connected?(str, 1, 1)
    refute QuickFindUF.connected?(str, 1, 2)
    refute QuickFindUF.connected?(str, 1, 3)
    refute QuickFindUF.connected?(str, 3, 4)
  end

  test "connects two entries" do
    str = QuickFindUF.new(2)

    new_str = QuickFindUF.union(str, 1, 2)

    assert QuickFindUF.connected?(new_str, 1, 2)
  end
end
