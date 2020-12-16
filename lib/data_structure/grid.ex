defmodule Grid do
  @moduledoc """
    Top left is starting point {0, 0}
    One position to the right is {1, 0}
    One position downward is {0, 1}
  """

  @doc """
    Takes a list of lists and returns a map of maps.
    Element at grid slot {1, 2} can be accessed by Grid.fetch(grid, 1, 2).

    ## Examples

      iex> Grid.build([["a", "b", "c"], ["d", "e", "f"], ["g", "h", "i"]])
      %{
        {0, 0} => "a", {1, 0} => "b", {2, 0} => "c",
        {0, 1} => "d", {1, 1} => "e", {2, 1} => "f",
        {0, 2} => "g", {1, 2} => "h", {2, 2} => "i"
      }
  """
  def build(input) do
    input
    |> Stream.map(&Util.normalize(&1, to: :indexed_map))
    |> Util.normalize(to: :indexed_map)
    |> Enum.flat_map(fn {y_idx, x_ary} ->
      Enum.map(x_ary, fn {x_idx, val} ->
        {{x_idx, y_idx}, val}
      end)
    end)
    |> Map.new()
  end

  def fetch(grid, pos) do
    grid[pos]
  end

  @doc """
    Returns the boundary of grid on x axis and y axis respectively.
  """
  def boundary(grid) do
    x_axis_boundary = grid |> Map.keys() |> Enum.map(&elem(&1, 0)) |> Enum.max
    y_axis_boundary = grid |> Map.keys() |> Enum.map(&elem(&1, 1)) |> Enum.max

    {x_axis_boundary, y_axis_boundary}
  end

  def put(grid, pos, new_val) do
    Map.put(grid, pos, new_val)
  end

  def positions(grid) do
    Map.keys(grid)
  end

  def values(grid) do
    Map.values(grid)
  end

  def map(grid, fun) do
    Enum.map(grid, fun) |> Map.new()
  end
end
