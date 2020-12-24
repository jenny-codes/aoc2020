defmodule Day10 do
  def run(input_path) do
    parsed =
      input_path
      |> FileUtil.parse()
      |> ListUtil.transform(element: :integer)
      |> Enum.to_list()
      |> add_init_values()
      |> Enum.sort()

    %{1 => ones, 3 => threes} =
      parsed
      |> Step.transform_to_difference([])
      |> Enum.frequencies()

    result1 = ones * threes
    result2 = Step.run_with_difference_optimized(parsed, 3)

    {result1, result2}
  end

  defp add_init_values(list) do
    start = 0
    finish = Enum.max(list) + 3

    [start, finish | list]
  end
end

IO.inspect(Day10.run("days/inputs/10.txt"))
