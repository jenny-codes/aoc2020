defmodule TwoSum do
  @doc """
  1. Takes a list of numbers, and find two items that add up to target.
  3. Returns a list, or :error.

    ## Examples

      iex> TwoSum.find([1, 2, 3, 4, 5], 9)
      [4, 5]

      iex> TwoSum.find([1, 2, 3, 4, 5], 100)
      nil
  """
  def find(pool, target) do
    run(pool, target)
  end

  defp run([_], _target), do: nil

  defp run([candidate | pool], target) do
    target_val = target - candidate

    if target_val in pool do
      [candidate, target_val]
    else
      run(pool, target)
    end
  end
end
