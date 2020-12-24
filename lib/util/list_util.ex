defmodule ListUtil do
  @doc """
    ## Examples

      iex> ListUtil.transform(["1", "2", "3"], element: :integer) |> Enum.to_list()
      [1, 2, 3]

      iex> ListUtil.transform(["1", "2", "3"], to: :indexed_map)
      %{0 => "1", 1 => "2", 2 => "3"}
  """
  @spec transform(list(), [{:element, :integer} | {:to, :indexed_map}, ...]) :: map() | Stream.t()
  def transform(list, element: :integer) do
    list
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.to_integer/1)
  end

  def transform(list, to: :indexed_map) do
    list
    |> Enum.with_index()
    |> Map.new(fn {elem, idx} -> {idx, elem} end)
  end
end
