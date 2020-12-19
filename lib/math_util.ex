defmodule MathUtil do
  # ===========================================
  # Greatest common divisor
  # ===========================================
  def gcd(a, 0), do: a
  def gcd(0, b), do: b
  def gcd(a, b), do: gcd(b, rem(a, b))

  def gcd(list) do
    Enum.reduce(list, 0, fn x, acc ->
      gcd(acc, x)
    end)
  end

  # ===========================================
  # Least common multiple
  # ===========================================
  def lcm(0, 0), do: 0
  def lcm(a, b), do: round(a * b / gcd(a, b))

  def lcm(list) do
    Enum.reduce(list, 1, fn x, acc ->
      lcm(acc, x)
    end)
  end

  # ===========================================
  # Extended Euclidean algorithm
  # ===========================================
  def ext_euclid(a, b) do
    ext_euclid(a, b, [1, 0], [0, 1])
  end

  def ext_euclid(a, 0, [ma, _], [mb, _]), do: {a, ma, mb}

  def ext_euclid(a, b, [ma1, ma2], [mb1, mb2]) do
    new_ma = ma1 - div(a, b) * ma2
    new_mb = mb1 - div(a, b) * mb2

    ext_euclid(b, rem(a, b), [ma2, new_ma], [mb2, new_mb])
  end

  # ===========================================
  # Chinese Remainder Theorem
  # Ref: https://en.wikipedia.org/wiki/Chinese_remainder_theorem#Using_the_existence_construction
  # ===========================================
  @spec crt([{integer(), integer()}]) :: integer()
  def crt(input) do
    {t, coef} =
      Enum.reduce(input, fn {y_const, y_coef}, {x_const, x_coef} ->
        run_crt_pair(x_const, x_coef, y_const, y_coef)
      end)

    add_until_positive(t, coef)
  end

  defp run_crt_pair(x_const, x_coef, y_const, y_coef) do
    {_, x_bezout_identity, y_bezout_identity} = ext_euclid(x_coef, y_coef)
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
