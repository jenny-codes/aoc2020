defmodule Day13 do
  @moduledoc """
  Puzzle 2 is solved by using Chinese Remainder Theorem.
  Also implemented Extended Euclidean algorithm in the implementation of CRT.
  """
  def run(file_path) do
    {target, intervals} = FileUtil.parse(file_path) |> Enum.to_list() |> normalize

    # Puzzle 1
    result1 =
      intervals
      |> Stream.map(&elem(&1, 1))
      |> Stream.reject(&(&1 == "x"))
      |> Stream.map(fn itv -> {itv, itv - rem(target, itv)} end)
      |> Enum.min_by(fn {_itv, diff} -> diff end)
      |> (fn {bus_id, diff} -> bus_id * diff end).()

    # Puzzle 2
    result2 =
      intervals
      |> Stream.reject(&(elem(&1, 1) == "x"))
      |> Enum.map(fn {k, v} -> {-k, v} end)
      |> MathUtil.crt()

    [result1: result1, result2: result2]
  end

  defp normalize([target_str, intervals_str]) do
    target = String.to_integer(target_str)

    intervals =
      intervals_str
      |> String.split(",")
      |> Enum.map(fn val ->
        case val do
          "x" -> "x"
          int_str -> String.to_integer(int_str)
        end
      end)
      |> EnumUtil.to_indexed_map()

    {target, intervals}
  end

  # ============================================================
  # Naive working solution for 13_test.txt
  # ============================================================

  # Input is list of {offset, itv}
  # Example: [{0, 7}, {1, 13}, {4, 59}, {6, 31}, {7, 19}]
  # Round 0: t = 7a
  # Round 1: t = (11 + 13a) * 7 = 77 + 91a
  defp find_smallest_t(input) do
    {t, _coef} =
      Enum.reduce(input, fn {y_const, y_coef}, {x_const, x_coef} ->
        smallest_satisfying_x(x_const, x_coef, y_const, y_coef)
      end)

    t
  end

  # Find the smallest x where
  # 1. t = x_coefficient * x + x_const = y * y_coefficient + y_const
  # 2. x is a positive int
  # 3. y is a positive int
  defp smallest_satisfying_x(x_const, x_coef, y_const, y_coef, x \\ 0) do
    result = x_coef * x + x_const

    if rem(result, y_coef) == y_coef - y_const do
      {result, y_coef * x_coef} |> IO.inspect()
    else
      smallest_satisfying_x(x_const, x_coef, y_const, y_coef, x + 1)
    end
  end
end

Day13.run("days/inputs/13.txt")
|> IO.inspect()
