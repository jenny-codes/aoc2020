defmodule ChineseRemainderTheoremTest do
  use ExUnit.Case

  test "run/1" do
    assert ChineseRemainderTheorem.run([{0, 3}, {3, 4}, {4, 5}]) == 39
    assert ChineseRemainderTheorem.run([{2, 3}, {3, 5}, {2, 7}]) == 23
    assert ChineseRemainderTheorem.run([{2, 3}, {3, 5}, {2, 7}, {1, 11}, {10, 13}]) == 23
  end
end
