defmodule BaseConverter do
  def from_base2(num), do: from_base2(num, to: :base10)

  def from_base2(num, to: :base10) do
    num
    |> Integer.digits()
    |> Integer.undigits(2)
  end

  def from_base2(num, transform: :list), do: from_base2(num, to: :base10, transform: :list)

  def from_base2(num, to: :base10, transform: :list) do
    num
    |> Integer.digits()
    |> Integer.undigits(2)
    |> Integer.digits()
  end

  def to_base2(num), do: to_base2(num, from: :base10)

  def to_base2(num, from: :base10) do
    num
    |> Integer.digits(2)
    |> Integer.undigits()
  end

  def to_base2(num, transform: :list), do: to_base2(num, from: :base10, transform: :list)

  def to_base2(num, from: :base10, transform: :list) do
    Integer.digits(num, 2)
  end
end
