defmodule ThreeDimGridTest do
  use ExUnit.Case
  doctest ThreeDimGrid

  setup_all do
    grid = %{
      {0, 0, 0} => "a",
      {1, 0, 0} => "b",
      {2, 0, 0} => "c",
      {0, 1, 1} => "d",
      {1, 1, 1} => "e",
      {2, 1, 1} => "f",
      {0, 2, 2} => "g",
      {1, 2, 2} => "h",
      {2, 2, -1} => "i"
    }

    {:ok, [grid: grid]}
  end

  describe "from_two_dim/1" do
    test "takes a 2D grid, returns a 3D grid with 0 as z-indice" do
      two_dim_grid = Grid.build([["a", "b", "c"], ["d", "e", "f"], ["g", "h", "i"]])

      expected_three_dim_grid = %{
        {0, 0, 0} => "a",
        {1, 0, 0} => "b",
        {2, 0, 0} => "c",
        {0, 1, 0} => "d",
        {1, 1, 0} => "e",
        {2, 1, 0} => "f",
        {0, 2, 0} => "g",
        {1, 2, 0} => "h",
        {2, 2, 0} => "i"
      }

      three_dim_grid = ThreeDimGrid.from_two_dim(two_dim_grid)

      assert three_dim_grid == expected_three_dim_grid
    end
  end

  describe "neighbors/2" do
    test "returns a subset of ThreeDimGrid that consists of 26 neighbors of position" do
      neighbors = ThreeDimGrid.neighbors({1, 1, 1})

      expected_neighbors = [
        {0, 0, 0},
        {0, 1, 1},
        {0, 2, 2},
        {1, 0, 0},
        {1, 2, 2},
        {2, 0, 0},
        {2, 1, 1},
        {0, 0, 1},
        {0, 0, 2},
        {0, 1, 0},
        {0, 1, 2},
        {0, 2, 0},
        {0, 2, 1},
        {1, 0, 1},
        {1, 0, 2},
        {1, 1, 0},
        {1, 1, 2},
        {1, 2, 0},
        {1, 2, 1},
        {2, 0, 1},
        {2, 0, 2},
        {2, 1, 0},
        {2, 1, 2},
        {2, 2, 0},
        {2, 2, 1},
        {2, 2, 2}
      ]

      assert MapSet.new(neighbors) == MapSet.new(expected_neighbors)
    end
  end
end
