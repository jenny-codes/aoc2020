defmodule ExtendedEuclideanTest do
  use ExUnit.Case

  test "run/2" do
    assert ExtendedEuclidean.run(240, 46) == {2, -9, 47}
    assert ExtendedEuclidean.run(3, 5) == {1, 2, -1}
    assert ExtendedEuclidean.run(5369, 31) == {1, -5, 866}
  end
end
