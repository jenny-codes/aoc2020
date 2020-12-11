defmodule Util do
  @doc """
    ## Examples

      iex> Util.normalize(["1", "2", "3"], to: :list, item: :integer)
      [1, 2, 3]

      iex> Util.normalize(["1", "2", "3"], to: :indexed_map)
      %{0 => "1", 1 => "2", 2 => "3"}
  """
  def normalize(raw_input, to: :list, item: :integer) do
    raw_input
    |> Stream.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
  end

  def normalize(raw_input, to: :indexed_map) do
    raw_input
    |> Enum.with_index()
    |> Map.new(fn {num, idx} -> {idx, num} end)
  end
end
