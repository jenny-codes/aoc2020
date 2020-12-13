defmodule Util do
  @doc """
    Example usages:
      Util.parse_file(file, to: :list, item: :integer)
      Util.parse_file(file, to: :indexed_map)
  """
  def parse_file(file_path, args) do
    file_path
    |> File.stream!()
    |> normalize(args)
  end

  @doc """
    ## Examples

      iex> Util.normalize(["1", "2", "3"], to: :list, item: :integer) |> Enum.to_list()
      [1, 2, 3]

      iex> Util.normalize(["1", "2", "3"], to: :list) |> Enum.to_list()
      ["1", "2", "3"]

      iex> Util.normalize(["1", "2", "3"], to: :indexed_map)
      %{0 => "1", 1 => "2", 2 => "3"}
  """
  def normalize(raw_input, to: :list, item: :integer) do
    raw_input
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.to_integer/1)
  end

  def normalize(raw_input, to: :list) do
    Stream.map(raw_input, &String.trim/1)
  end

  def normalize(raw_input, to: :indexed_map) do
    raw_input
    |> Enum.with_index()
    |> Map.new(fn {num, idx} -> {idx, num} end)
  end
end
