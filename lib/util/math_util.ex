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
end
