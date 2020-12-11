defmodule MultiSum do
  @doc """
  1. Takes a list, and find continuous items that add up to target.
  2. One-item results do not satisfy.
  3. Returns a list of values, or nil.

    ## Examples

      iex> MultiSum.find_continuous([1, 2, 3, 4, 5], 12)
      [3, 4, 5]

      iex> MultiSum.find_continuous([1, 2, 3, 4, 5], 100)
      nil
  """
  @spec find_continuous(list(), integer()) :: [integer()] | nil
  def find_continuous(pool, target) do
    internal_struct = build_structure(pool)
    window_scan(internal_struct, target, 0, 1, :up, internal_struct[0] + internal_struct[1])
  end

  defp build_structure(list) do
    list
    |> Enum.with_index()
    |> Map.new(fn {num, idx} -> {idx, num} end)
  end

  # Tada!
  defp window_scan(pool, target, low_ptr, high_ptr, _dir, acc) when acc == target do
    Enum.map(low_ptr..high_ptr, &pool[&1])
  end

  defp window_scan(pool, target, low_ptr, high_ptr, dir, acc) do
    is_at_top = high_ptr == pool |> Map.keys() |> Enum.max()
    is_at_bottom = low_ptr == pool |> Map.keys() |> Enum.min()
    is_going_up = dir == :up
    is_going_down = dir == :down

    cond do
      is_at_top and is_at_bottom ->
        nil

      is_at_top and is_going_up ->
        window_scan(
          pool,
          target,
          low_ptr - 1,
          high_ptr,
          :down,
          acc + pool[low_ptr - 1]
        )

      is_at_bottom and is_going_down ->
        window_scan(
          pool,
          target,
          low_ptr,
          high_ptr + 1,
          :up,
          acc + pool[high_ptr + 1]
        )

      is_going_up ->
        window_scan(
          pool,
          target,
          low_ptr + 1,
          high_ptr + 1,
          :up,
          acc + pool[high_ptr + 1] - pool[low_ptr]
        )

      is_going_down ->
        window_scan(
          pool,
          target,
          low_ptr - 1,
          high_ptr - 1,
          :down,
          acc + pool[low_ptr - 1] - pool[high_ptr]
        )
    end
  end
end
