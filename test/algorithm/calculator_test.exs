defmodule CalculatorTest do
  use ExUnit.Case
  doctest Calculator

  describe "V1" do
    test "evaluate sequentially when without paranthesis" do
      assert Calculator.run("1 + 2 * 3") == 9
    end

    test "evaluate parenthesis first, one layer" do
      assert Calculator.run("1 * (2 + 3)") == 5
      assert Calculator.run("1 * (2 + 3) * 4") == 20
      assert Calculator.run("1 * (2 + 3) * (4 + 5)") == 45
    end

    test "evaluate parenthesis first, multiple layers" do
      assert Calculator.run("1 * ((2 + 3) * 4)") == 20
      assert Calculator.run("1 * (2 + (3 * 4))") == 14
    end
  end

  describe "V2" do
    test "evaluate plus sign first" do
      assert Calculator.V2.run("1 + 2 * 3") == 9
      assert Calculator.V2.run("1 * 2 + 3") == 5
    end

    test "evaluate parenthesis first, one layer" do
      assert Calculator.V2.run("1 * (2 + 3)") == 5
      assert Calculator.V2.run("1 * (2 + 3) * 4") == 20
      assert Calculator.V2.run("1 * (2 + 3) * (4 + 5)") == 45
    end

    test "evaluate parenthesis first, multiple layers" do
      assert Calculator.V2.run("1 * ((2 * 3) + 4)") == 10
      assert Calculator.V2.run("1 * (2 + (3 * 4))") == 14
    end
  end
end
