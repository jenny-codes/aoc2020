defmodule Grid do
  @moduledoc """
    Top left is starting point {0, 0}
    One position to the right is {1, 0}
    One position downward is {0, 1}
  """

  @doc """
  Output format:

  %{
    1 => {1 => ".", 2 => "#"},
    2 => {1 => ".", 2 => "#"},
    ...
  }
  """
  def draw(input) do
    input
    |> Stream.with_index()
    |> Stream.map(fn {line, y_idx} ->
      x_values =
        line
        |> String.split("", trim: true)
        |> Stream.with_index()
        |> Stream.map(fn {char, x_idx} -> {x_idx, char} end)
        |> Map.new()

      {y_idx, x_values}
    end)
    |> Map.new()
  end

  def traverse_and_collect(grid, slope) do
    traverse_and_collect(grid, fetch_boundries(grid), slope, 0, {0, 0})
  end

  def traverse_and_collect(
        grid,
        {x_boundry, y_boundry},
        {right_step, down_step},
        curr_count,
        {curr_x, curr_y}
      ) do
    if curr_y >= y_boundry do
      curr_count
    else
      next_count =
        if grid[curr_y][curr_x] == "#" do
          curr_count + 1
        else
          curr_count
        end

      next_x = rem(curr_x + right_step, x_boundry)
      next_y = curr_y + down_step

      traverse_and_collect(
        grid,
        {x_boundry, y_boundry},
        {right_step, down_step},
        next_count,
        {next_x, next_y}
      )
    end
  end

  defp fetch_boundries(grid) do
    x_boundry = grid[0] |> Enum.count()
    y_boundry = grid |> Enum.count()

    {x_boundry, y_boundry}
  end
end

defmodule Day3 do
  def run(input) do
    grid =
      input
      |> File.stream!()
      |> Stream.map(&String.trim/1)
      |> Grid.draw()

    grid
    |> Grid.traverse_and_collect({3, 1})
    |> IO.inspect(label: "Result1")

    [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]
    |> Enum.map(fn slope -> Grid.traverse_and_collect(grid, slope) end)
    |> Enum.reduce(&(&1 * &2))
    |> IO.inspect(label: "Result2")
  end
end
