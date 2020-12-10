defmodule XMAS do
  @doc """
    Apparantly it's "eXchange-Masking Addition System"
  """

  def build(input) do
    input
    |> Stream.map(&String.to_integer/1)
    |> Stream.with_index()
    |> Map.new(fn {num, idx} -> {idx, num} end)
  end

  def find_first_invalid(xmas, preamble: preamble) do
    find_first_invalid(xmas, 0, preamble)
  end

  defp find_first_invalid(xmas, ptr, preamble) do
    if is_valid(xmas, ptr, preamble) do
      find_first_invalid(xmas, ptr + 1, preamble)
    else
      xmas[ptr]
    end
  end

  # def recursive_find(xmas, target, ptr, acc, fun)

  defp is_valid(_xmas, key, preamble) when key < preamble, do: true

  defp is_valid(xmas, key, preamble) do
    Enum.map((key - preamble)..(key - 1), &xmas[&1])
    |> find_two_sum(xmas[key])
  end

  defp find_two_sum(pool, target) do
    IO.inspect(target, label: "Finding two sum for")
    find_two_sum(tl(pool), hd(pool), target)
  end

  defp find_two_sum([], _pinned_candidate, _target), do: false

  defp find_two_sum(pool, pinned_candidate, target) do
    [second_candidate | tail] = pool

    pinned_candidate + second_candidate == target ||
      find_two_sum(tail, pinned_candidate, target) ||
      find_two_sum(tail, second_candidate, target)
  end

  @doc """
    If hit target, return the set of contiguous numbers that add up to this target.
  """
  def find_multiple_sum(xmas, target) do
    find_multiple_sum(xmas, target, 0, 1, :up, xmas[0] + xmas[1])
  end

  # Tada!
  def find_multiple_sum(xmas, target, low_ptr, high_ptr, _dir, acc) when acc == target do
    Enum.map(low_ptr..high_ptr, &xmas[&1])
  end

  def find_multiple_sum(xmas, target, low_ptr, high_ptr, dir, acc) do
    is_at_top = high_ptr == xmas |> Map.keys() |> Enum.max()
    is_at_bottom = low_ptr == xmas |> Map.keys() |> Enum.min()
    is_going_up = dir == :up
    is_going_down = dir == :down

    cond do
      is_at_top and is_going_up ->
        find_multiple_sum(xmas, target, low_ptr - 1, high_ptr, :down, acc + xmas[low_ptr - 1])

      is_at_bottom and is_going_down ->
        find_multiple_sum(xmas, target, low_ptr, high_ptr + 1, :up, acc + xmas[high_ptr + 1])

      is_going_up ->
        find_multiple_sum(
          xmas,
          target,
          low_ptr + 1,
          high_ptr + 1,
          :up,
          acc + xmas[high_ptr + 1] - xmas[low_ptr]
        )

      is_going_down ->
        find_multiple_sum(
          xmas,
          target,
          low_ptr - 1,
          high_ptr - 1,
          :down,
          acc + xmas[low_ptr - 1] - xmas[high_ptr]
        )

      true ->
        "Ugh something went wrong."
    end
  end
end

defmodule Day9 do
  def run(input) do
    xmas =
      input
      |> File.stream!()
      |> Stream.map(&String.trim/1)
      |> XMAS.build()

    xmas
    |> XMAS.find_first_invalid(preamble: 25)
    |> IO.inspect(label: "Result1")

    xmas
    |> XMAS.find_multiple_sum(1_212_510_616)
    |> Enum.min_max()
    |> (fn {min, max} -> min + max end).()
    |> IO.inspect(label: "Result2")
  end
end

Day9.run("days/inputs/day9.txt")
