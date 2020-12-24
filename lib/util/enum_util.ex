defmodule EnumUtil do
  @doc """
    Transforms each element in the enum.
    Use `lazy` option to return a stream instead of list.

    ## Examples

      iex> EnumUtil.transform_element(["1", "2", "3"], Integer, lazy: false)
      [1, 2, 3]
  """
  @spec transform_element(Enumerable.t(), Integer, [{:lazy, any}, ...]) ::
          Enumerable.t() | Stream.t()
  def transform_element(enum, Integer, lazy: lazy) do
    if lazy do
      Stream.map(enum, &String.to_integer/1)
    else
      Enum.map(enum, &String.to_integer/1)
    end
  end

  @doc """
    ## Examples

      iex> EnumUtil.to_indexed_map(["1", "2", "3"])
      %{0 => "1", 1 => "2", 2 => "3"}
  """
  @spec to_indexed_map(Enumerable.t()) :: map()
  def to_indexed_map(enum) do
    enum
    |> Enum.with_index()
    |> Map.new(fn {elem, idx} -> {idx, elem} end)
  end
end
