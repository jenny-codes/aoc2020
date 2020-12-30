defmodule Day18 do
  def run(input_path) do
    input = FileUtil.parse(input_path)

    result1 =
      input
      |> Enum.map(&Calculator.run/1)
      |> Enum.sum()

    result2 =
      input
      |> Enum.map(&Calculator.V2.run/1)
      |> Enum.sum()

    [result1: result1, result2: result2]
  end
end

Day18.run("days/inputs/18.txt")
|> IO.inspect()
