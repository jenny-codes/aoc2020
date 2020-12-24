defmodule TreeGrid do
  @moduledoc """
    Top left is starting point {0, 0}
    One position to the right is {1, 0}
    One position downward is {0, 1}
  """
  def build(input) do
    Grid.build(input)
  end

  def traverse_and_collect(tree_grid, slope) do
    traverse_and_collect(tree_grid, Grid.boundary(tree_grid), slope, 0, {0, 0})
  end

  def traverse_and_collect(
        tree_grid,
        {x_boundry, y_boundry},
        {right_step, down_step},
        curr_count,
        {curr_x, curr_y}
      ) do
    if curr_y >= y_boundry do
      curr_count
    else
      next_count =
        if Grid.fetch(tree_grid, {curr_x, curr_y}) == "#" do
          curr_count + 1
        else
          curr_count
        end

      next_x = rem(curr_x + right_step, x_boundry)
      next_y = curr_y + down_step

      traverse_and_collect(
        tree_grid,
        {x_boundry, y_boundry},
        {right_step, down_step},
        next_count,
        {next_x, next_y}
      )
    end
  end
end

defmodule Day3 do
  def run(input_path) do
    tree_grid =
      input_path
      |> FileUtil.parse()
      |> Stream.map(&String.split(&1, "", trim: true))
      |> TreeGrid.build()

    result1 = TreeGrid.traverse_and_collect(tree_grid, {3, 1})

    result2 =
      [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]
      |> Enum.map(fn slope -> TreeGrid.traverse_and_collect(tree_grid, slope) end)
      |> Enum.reduce(&(&1 * &2))

    {result1, result2}
  end
end

Day3.run("days/inputs/3.txt")
|> IO.inspect()
