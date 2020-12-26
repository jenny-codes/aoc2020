defmodule FourDimGrid do
  @moduledoc """
  This is an space-unlimited four-dimensional grid.
  Implemented on top of the Grid structure.
    Top left is starting point {0, 0}
    One position to the right is {1, 0}
    One position downward is {0, 1}
  """

  @doc """
    Takes a 2D grid and returns a 3D grid with 0 as z indices.
    Behaves like the 2D grid.

    ## Examples

      iex> Grid.build([["a", "b", "c"], ["d", "e", "f"], ["g", "h", "i"]])
      iex> |> ThreeDimGrid.from_two_dim
      %{
        {0, 0, 0} => "a", {1, 0, 0} => "b", {2, 0, 0} => "c",
        {0, 1, 0} => "d", {1, 1, 0} => "e", {2, 1, 0} => "f",
        {0, 2, 0} => "g", {1, 2, 0} => "h", {2, 2, 0} => "i"
      }
  """
  def from_two_dim(two_dim_grid) do
    two_dim_grid
    |> Grid.map(fn {{x, y}, val} -> {{x, y, 0, 0}, val} end)
  end

  def is_registered(grid, {pos, _}) do
    pos in Grid.positions(grid)
  end

  @doc """
  Returns a subset of ThreeDimGrid that consists of 26  neighboring positions and their values.
  """
  def neighbors({x, y, z, w}) do
    for x_adj <- [1, 0, -1], y_adj <- [1, 0, -1], z_adj <- [1, 0, -1], w_adj <- [1, 0, -1] do
      {x + x_adj, y + y_adj, z + z_adj, w + w_adj}
    end
    # Filter out itself
    |> Enum.reject(&(&1 == {x, y, z, w}))
  end

  @spec put(map, any, any) :: map
  def put(grid, pos, new_val) do
    Grid.put(grid, pos, new_val)
  end

  @spec positions(map) :: [any]
  def positions(grid) do
    Grid.positions(grid)
  end

  def values(grid) do
    Grid.values(grid)
  end

  def map(grid, fun) do
    Grid.map(grid, fun)
  end

  def new(data) do
    Map.new(data)
  end
end
