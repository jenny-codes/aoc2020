defmodule Game do
  def run(init_vals, count) do
    memo = setup(init_vals)
    i = Enum.count(init_vals) + 1

    next(0, i, count, memo)
  end

  def next(num, i, target, _memo) when i == target, do: num

  def next(num, i, target, memo) do
    case memo[num] do
      nil ->
        next(0, i + 1, target, Map.put(memo, num, i))

      last_i ->
        next(i - last_i, i + 1, target, Map.put(memo, num, i))
    end
  end

  def setup(init_vals) do
    init_vals
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {val, idx}, acc ->
      Map.put(acc, val, idx + 1)
    end)
  end
end

defmodule Day15 do
  def run(input) do
    result1 = Game.run(input, 2020)
    result2 = Game.run(input, 30_000_000)

    [result1: result1, result2: result2]
  end
end

Day15.run([6, 13, 1, 15, 2, 0])
|> IO.inspect()
