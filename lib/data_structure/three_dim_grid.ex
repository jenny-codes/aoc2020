defmodule ThreeDimGrid do
  @moduledoc """
  This is an space-unlimited three-dimensional grid.
    Top left is starting point {0, 0}
    One position to the right is {1, 0}
    One position downward is {0, 1}
  """

  @doc """
    Takes a 2D grid and returns a 3D grid with 0 as z indices.
    Implemented on top of the Grid structure.

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
    |> Grid.map(fn {{x, y}, val} -> {{x, y, 0}, val} end)
  end

  @spec fetch(nil | maybe_improper_list | map, any) :: any
  def fetch(grid, pos) do
    Grid.fetch(grid, pos)
  end

  @doc """
  Returns a subset of ThreeDimGrid that consists of 26 neighboring positions.
  """
  def neighbors({x, y, z}) do
    for x_adj <- [1, 0, -1], y_adj <- [1, 0, -1], z_adj <- [1, 0, -1] do
      {x + x_adj, y + y_adj, z + z_adj}
    end
    # Filter out itself
    |> Enum.reject(&(&1 == {x, y, z}))
  end
end
