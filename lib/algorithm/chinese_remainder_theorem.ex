defmodule ChineseRemainderTheorem do
  @moduledoc """
  Ref: https://en.wikipedia.org/wiki/Chinese_remainder_theorem#Using_the_existence_construction
  """

  @spec run([{integer(), integer()}]) :: integer()
  def run(input) do
    {t, coef} =
      Enum.reduce(input, fn {y_const, y_coef}, {x_const, x_coef} ->
        run_crt_pair(x_const, x_coef, y_const, y_coef)
      end)

    add_until_positive(t, coef)
  end

  defp run_crt_pair(x_const, x_coef, y_const, y_coef) do
    {_, x_bezout_identity, y_bezout_identity} = ExtendedEuclidean.run(x_coef, y_coef)
    new_coef = x_coef * y_coef
    new_const = y_const * x_bezout_identity * x_coef + x_const * y_bezout_identity * y_coef

    {new_const, new_coef}
  end

  defp add_until_positive(const, coef) do
    if const > 0 do
      const
    else
      (Integer.floor_div(abs(const), coef) + 1) * coef + const
    end
  end
end
