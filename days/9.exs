defmodule XMAS do
  @doc """
    Apparantly it's "eXchange-Masking Addition System"
  """
  def find_invalid(xmas, preamble: preamble) do
    xmas
    |> Util.normalize(to: :indexed_map)
    |> find_invalid(0, preamble)
  end

  defp find_invalid(xmas_map, ptr, preamble) do
    if is_valid(xmas_map, ptr, preamble) do
      find_invalid(xmas_map, ptr + 1, preamble)
    else
      xmas_map[ptr]
    end
  end

  defp is_valid(_xmas, key, preamble) when key < preamble, do: true

  defp is_valid(xmas_map, key, preamble) do
    pool = Enum.map((key - preamble)..(key - 1), &xmas_map[&1])
    is_list(TwoSum.find(pool, xmas_map[key]))
  end
end

defmodule Day9 do
  def run(input_path) do
    xmas = Util.normalize_file(input_path, to: :list, item: :integer)

    xmas
    |> XMAS.find_invalid(preamble: 25)
    |> IO.inspect(label: "Puzzle 1")

    xmas
    |> MultiSum.find_continuous(result1)
    |> Enum.min_max()
    |> (fn {min, max} -> min + max end).()
    |> IO.inspect(label: "Puzzle 2")
  end
end

Day9.run("days/inputs/9.txt")
