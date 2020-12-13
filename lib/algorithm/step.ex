defmodule Step do
  @doc """
  1. Takes an ordered list of numbers
  2. Count of all possible combinations from the first to reach the last item within :step.
  3. Return the count

    ## Examples

      iex> Step.run_recursive([0, 1, 2], 1)
      1

      # iex> Step.run_recursive([0, 1, 2], 2)
      # 2
  """
  def run_recursive(list, step) do
    run_recursive(list, Enum.max(list), step)
  end

  def run_recursive_optimized(list, step) do
    run_recursive_optimized(list, Enum.max(list), step)
  end

  def run_concurrent(list, step) do
    run_concurrent(list, Enum.max(list), step)
  end

  def run_with_difference(list, step) do
    transform_to_difference(list, [])
    |> Stream.chunk_by(&(&1 == 3))
    |> Stream.reject(&(3 in &1))
    |> Stream.map(&Enum.count/1)
    |> Enum.reduce(1, fn sub_length, acc ->
      new_val =
        0..sub_length
        |> Enum.to_list()
        |> run_recursive(step)

      new_val * acc
    end)
  end

  def run_with_difference_optimized(list, step) do
    transform_to_difference(list, [])
    |> Stream.chunk_by(&(&1 == step))
    |> Stream.reject(&(step in &1))
    |> Stream.map(&Enum.count/1)
    |> Enum.frequencies()
    |> Enum.reduce(1, fn {sub_length, count}, acc ->
      val =
        0..sub_length
        |> Enum.to_list()
        |> run_recursive(step)

      acc * :math.pow(val, count)
    end)
  end

  def transform_to_difference([_], acc), do: Enum.reverse(acc)

  def transform_to_difference(original, acc) do
    [first, second | tail] = original

    transform_to_difference([second | tail], [second - first | acc])
  end

  # ---------------------------------------------------------------
  # Original
  # ---------------------------------------------------------------

  defp run_recursive([last], target, _step) do
    if last == target do
      1
    else
      0
    end
  end

  defp run_recursive([curr, next | _tail], _target, step) when next - curr > step, do: 0

  defp run_recursive([curr, next | tail], target, step) do
    run_recursive([curr | tail], target, step) + run_recursive([next | tail], target, step)
  end

  # ---------------------------------------------------------------
  # Original optimized
  # ---------------------------------------------------------------

  defp run_recursive_optimized([last], target, _step) do
    if last == target do
      1
    else
      0
    end
  end

  defp run_recursive_optimized([curr, next | tail], target, step) do
    difference = next - curr

    cond do
      difference > step ->
        0

      difference == step ->
        run_recursive_optimized([next | tail], target, step)

      difference < step ->
        run_recursive_optimized([curr | tail], target, step) +
          run_recursive_optimized([next | tail], target, step)
    end
  end

  # ---------------------------------------------------------------
  # Concurrent
  # ---------------------------------------------------------------

  defp run_concurrent([last], target, _step) do
    if last == target do
      1
    else
      0
    end
  end

  defp run_concurrent([curr, next | _tail], _target, step) when next - curr > step, do: 0

  defp run_concurrent([curr, next | tail], target, step) do
    async1 = Task.async(fn -> run_concurrent([curr | tail], target, step) end)
    async2 = Task.async(fn -> run_concurrent([next | tail], target, step) end)

    Task.await(async1) + Task.await(async2)
  end
end
