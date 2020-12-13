defmodule Step do
  @doc """
  1. Takes an ordered list of numbers
  2. Count of all possible combinations from the first to reach the last item within :step.
  3. Return the count

    ## Examples

      iex> Step.find_all_possible([0, 1, 2], 1)
      1

      # iex> Step.find_all_possible([0, 1, 2], 2)
      # 2
  """
  def find_all_possible(list, step) do
    run(list, Enum.max(list), step)
  end

  defp run([last], target, _step) do
    if last == target do
      1
    else
      0
    end
  end

  defp run([curr, next | _tail], _target, step) when next - curr > step, do: 0

  defp run([curr, next | tail], target, step) do
    run([curr | tail], target, step) + run([next | tail], target, step)
  end
end
