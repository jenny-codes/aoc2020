defmodule GridTest do
  use ExUnit.Case
  doctest Grid

  setup_all do
    grid = %{
      {0, 0} => "a",
      {1, 0} => "b",
      {2, 0} => "c",
      {0, 1} => "d",
      {1, 1} => "e",
      {2, 1} => "f",
      {0, 2} => "g",
      {1, 2} => "h",
      {2, 2} => "i"
    }

    {:ok, [grid: grid]}
  end

  describe "build/1" do
    test "takes a list of lists, returns a map of maps", context do
      input = [["a", "b", "c"], ["d", "e", "f"], ["g", "h", "i"]]

      output = Grid.build(input)

      expected_output = context[:grid]

      assert output == expected_output
    end
  end

  describe "fetch/2" do
    test "returns the value at {x, y}", context do
      value = Grid.fetch(context[:grid], {1, 1})

      assert value == "e"
    end
  end

  describe "boundary/1" do
    test "returns the boundary of grid on x axis and y axis", context do
      boundary = Grid.boundary(context[:grid])

      assert boundary == {2, 2}
    end
  end

  describe "put/3" do
    test "returns a new grid with the value at given position updated", context do
      new_grid = Grid.put(context[:grid], {1, 1}, "new value")

      assert Grid.fetch(new_grid, {1, 1}) == "new value"
    end
  end

  describe "all_positions/1" do
    test "returns all the positions in a grid, order not guaranteed", context do
      all_pos = Grid.all_positions(context[:grid])

      expected = [
        {0, 0},
        {1, 0},
        {2, 0},
        {0, 1},
        {1, 1},
        {2, 1},
        {0, 2},
        {1, 2},
        {2, 2}
      ]

      assert MapSet.new(all_pos) == MapSet.new(expected)
    end
  end

  describe "map/2" do
    test "works like Enum.map function", context do
      transformed =
        Grid.map(context[:grid], fn {pos, val} ->
          {pos, val <> val}
        end)

      expected_output = %{
        {0, 0} => "aa",
        {1, 0} => "bb",
        {2, 0} => "cc",
        {0, 1} => "dd",
        {1, 1} => "ee",
        {2, 1} => "ff",
        {0, 2} => "gg",
        {1, 2} => "hh",
        {2, 2} => "ii"
      }

      assert transformed == expected_output
    end
  end
end
