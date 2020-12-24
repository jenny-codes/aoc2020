defmodule MathUtilTest do
  use ExUnit.Case

  describe "gcd" do
    test "works with a list" do
      assert MathUtil.gcd([1, 3]) == 1
      assert MathUtil.gcd([2, 3]) == 1
      assert MathUtil.gcd([2, 4]) == 2
      assert MathUtil.gcd([2, 4, 6]) == 2
      assert MathUtil.gcd([2, 4, 6, 12]) == 2
    end

    test "returns value when the other input is 0" do
      assert MathUtil.gcd(3, 0) == 3
      assert MathUtil.gcd(0, 3) == 3
    end
  end

  describe "lcm" do
    test "works with a list" do
      assert MathUtil.lcm([1, 3]) == 3
      assert MathUtil.lcm([2, 3]) == 6
      assert MathUtil.lcm([2, 4]) == 4
      assert MathUtil.lcm([6, 4]) == 12
      assert MathUtil.lcm([3, 4, 6]) == 12
      assert MathUtil.lcm([3, 4, 5, 6]) == 60
    end
  end

  describe "ext_euclid" do
    test "works" do
      assert MathUtil.ext_euclid(240, 46) == {2, -9, 47}
      assert MathUtil.ext_euclid(3, 5) == {1, 2, -1}
      assert MathUtil.ext_euclid(5369, 31) == {1, -5, 866}
    end
  end

  describe "crt" do
    test "works" do
      assert MathUtil.crt([{0, 3}, {3, 4}, {4, 5}]) == 39
      assert MathUtil.crt([{2, 3}, {3, 5}, {2, 7}]) == 23
      assert MathUtil.crt([{2, 3}, {3, 5}, {2, 7}, {1, 11}, {10, 13}]) == 23
    end
  end
end
