defmodule Day1 do
  def run(input) do
    processed_input =
      input
      |> File.stream!()
      |> Stream.map(&String.trim/1)
      |> Enum.map(&String.to_integer/1)

    result1 =
      processed_input
      |> find_2_for(2020)
      |> Enum.reduce(&*/2)

    result2 =
      processed_input
      |> find_3_for(2020)
      |> Enum.reduce(&*/2)

    IO.inspect(result1, label: "Puzzle 1")
    IO.inspect(result2, label: "Puzzle 2")
  end

  defp find_2_for([], _target), do: nil

  defp find_2_for([val1 | pool], target) do
    find_sum(target, val1, pool) || find_2_for(pool, target)
  end

  defp find_3_for([val1 | pool], target) do
    case find_2_for(pool, target - val1) do
      nil -> find_3_for(pool, target)
      values -> [val1 | values]
    end
  end

  defp find_sum(_target, _val1, []), do: nil
  defp find_sum(target, val1, [val2 | _pool]) when val1 + val2 == target, do: [val1, val2]
  defp find_sum(target, val1, [_val2 | pool]), do: find_sum(target, val1, pool)
end
