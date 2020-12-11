defmodule Aoc2020Test do
  use ExUnit.Case
  doctest Aoc2020

  test "day1" do
    assert true
  end

  test "day2" do
    assert true
  end

  test "day3" do
    assert true
  end

  test "day4" do
    assert true
  end

  test "day5" do
    assert true
  end

  test "day6" do
    assert true
  end

  test "day7" do
    assert true
  end

  test "day8" do
    assert true
  end

  @tag :today
  test "day9" do
    {result1, result2} = Aoc2020.day9()

    assert result1 == 1_212_510_616
    assert result2 == 171_265_123
  end
end
