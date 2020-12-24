defmodule FileUtil do
  @doc """
  Parse a file content to a trimmed list.
  """
  def parse(file_path) do
    file_path
    |> File.stream!()
    |> Stream.map(&String.trim/1)
  end
end
