defmodule ExtendedEuclidean do
  @moduledoc """
  Extended Euclidean algorithm is the following:
  Given two numbers `a` and `b`, find the `x`, `y` and `z` where
  - `z` is the greatest common divider of `a` and `b`.
  - `x` and `y` are the coefficient of `a` and `b` that satisfy the equation
    ```
    ax + by = z
    ```
  """
  def run(a, b) do
    run(a, b, [1, 0], [0, 1])
  end

  def run(a, 0, [x, _], [y, _]), do: {a, x, y}

  def run(a, b, [x1, x2], [y1, y2]) do
    new_x = x1 - div(a, b) * x2
    new_y = y1 - div(a, b) * y2

    run(b, rem(a, b), [x2, new_x], [y2, new_y])
  end
end
