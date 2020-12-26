defmodule FourDimGridTest do
  use ExUnit.Case
  doctest FourDimGrid

  setup_all do
    grid = %{
      {0, 0, 0, 1} => "a",
      {1, 0, 0, 1} => "b",
      {2, 0, 0, 1} => "c"
    }

    {:ok, [grid: grid]}
  end

  describe "from_two_dim/1" do
    test "takes a 2D grid, returns a 3D grid with 0 as z-indice" do
      two_dim_grid = Grid.build([["a", "b", "c"], ["d", "e", "f"], ["g", "h", "i"]])

      expected_four_dim_grid = %{
        {0, 0, 0, 0} => "a",
        {1, 0, 0, 0} => "b",
        {2, 0, 0, 0} => "c",
        {0, 1, 0, 0} => "d",
        {1, 1, 0, 0} => "e",
        {2, 1, 0, 0} => "f",
        {0, 2, 0, 0} => "g",
        {1, 2, 0, 0} => "h",
        {2, 2, 0, 0} => "i"
      }

      four_dim_grid = FourDimGrid.from_two_dim(two_dim_grid)

      assert four_dim_grid == expected_four_dim_grid
    end
  end

  describe "neighbors/2" do
    test "returns a subset of FourDimGrid that consists of 26 neighbors of position" do
      neighbors = FourDimGrid.neighbors({0, 0, 0, 0})

      assert Enum.count(neighbors) == 80
    end
  end
end
