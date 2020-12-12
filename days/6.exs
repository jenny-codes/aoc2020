defmodule Day6 do
  def run(input) do
    input
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> parse_to_answer_groups(mode: :union)
    |> Stream.map(&MapSet.size/1)
    |> Enum.sum()
    |> IO.inspect(label: "Result1")

    input
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> parse_to_answer_groups(mode: :intersect)
    |> Stream.map(&MapSet.size/1)
    |> Enum.sum()
    |> IO.inspect(label: "Result2")
  end

  defp parse_to_answer_groups(input, mode: :union) do
    Enum.reduce(input, [], fn line, acc ->
      if line == "" do
        [MapSet.new() | acc]
      else
        [record | tail] = acc

        new_answers =
          line
          |> String.split("", trim: true)
          |> MapSet.new()

        [MapSet.union(record, new_answers) | tail]
      end
    end)
  end

  defp parse_to_answer_groups(input, mode: :intersect) do
    Enum.reduce(input, [], fn line, acc ->
      if line == "" do
        [:new | acc]
      else
        [record | tail] = acc

        new_answers =
          line
          |> String.split("", trim: true)
          |> MapSet.new()

        if record == :new do
          [new_answers | tail]
        else
          [MapSet.intersection(record, new_answers) | tail]
        end
      end
    end)
  end
end

Day6.run("days/inputs/6.txt")
