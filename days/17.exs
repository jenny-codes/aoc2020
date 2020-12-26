defmodule ConwayCube do
  @active "#"

  def init(data) do
    data
    |> Grid.build()
    |> ThreeDimGrid.from_two_dim()
    |> fetch_active_coords()
  end

  def run_cycles(active_coords, count) do
    Enum.reduce(1..count, active_coords, fn _, acc ->
      next_cycle(acc)
    end)
  end

  @doc """
  If a cube is active and exactly 2 or 3 of its neighbors are also active,
    the cube remains active. Otherwise, the cube becomes inactive.
  If a cube is inactive but exactly 3 of its neighbors are active,
    the cube becomes active. Otherwise, the cube remains inactive.
  """
  def next_cycle(active_coords) do
    active_neighbors_table =
      active_coords
      |> Enum.flat_map(&ThreeDimGrid.neighbors/1)
      |> Enum.frequencies()

    new_actives_rule_2 =
      active_neighbors_table
      |> Stream.filter(fn {_coord, count} -> count == 2 end)
      |> Stream.map(&elem(&1, 0))
      |> Stream.filter(fn coord -> coord in active_coords end)
      |> Enum.to_list()

    new_actives_rule_3 =
      active_neighbors_table
      |> Stream.filter(fn {_coord, count} -> count == 3 end)
      |> Stream.map(&elem(&1, 0))
      |> Enum.to_list()

    [new_actives_rule_2 | new_actives_rule_3] |> List.flatten()
  end

  defp fetch_active_coords(cube) do
    cube
    |> Stream.filter(fn {_coord, val} -> val == @active end)
    |> Stream.map(&elem(&1, 0))
    |> Enum.to_list()
  end
end

defmodule HyperCube do
  @active "#"

  def init(data) do
    data
    |> Grid.build()
    |> FourDimGrid.from_two_dim()
    |> fetch_active_coords()
  end

  def run_cycles(active_coords, count) do
    Enum.reduce(1..count, active_coords, fn _, acc ->
      next_cycle(acc)
    end)
  end

  @doc """
  If a cube is active and exactly 2 or 3 of its neighbors are also active,
    the cube remains active. Otherwise, the cube becomes inactive.
  If a cube is inactive but exactly 3 of its neighbors are active,
    the cube becomes active. Otherwise, the cube remains inactive.
  """
  def next_cycle(active_coords) do
    active_neighbors_table =
      active_coords
      |> Enum.flat_map(&FourDimGrid.neighbors/1)
      |> Enum.frequencies()

    new_actives_rule_2 =
      active_neighbors_table
      |> Stream.filter(fn {_coord, count} -> count == 2 end)
      |> Stream.map(&elem(&1, 0))
      |> Stream.filter(fn coord -> coord in active_coords end)
      |> Enum.to_list()

    new_actives_rule_3 =
      active_neighbors_table
      |> Stream.filter(fn {_coord, count} -> count == 3 end)
      |> Stream.map(&elem(&1, 0))
      |> Enum.to_list()

    [new_actives_rule_2 | new_actives_rule_3] |> List.flatten()
  end

  defp fetch_active_coords(cube) do
    cube
    |> Stream.filter(fn {_coord, val} -> val == @active end)
    |> Stream.map(&elem(&1, 0))
    |> Enum.to_list()
  end
end

defmodule Day17 do
  def run(input_path) do
    result1 =
      input_path
      |> FileUtil.parse()
      |> Stream.map(&String.split(&1, "", trim: true))
      |> ConwayCube.init()
      |> ConwayCube.run_cycles(6)
      |> Enum.count()

    result2 =
      input_path
      |> FileUtil.parse()
      |> Stream.map(&String.split(&1, "", trim: true))
      |> HyperCube.init()
      |> HyperCube.run_cycles(6)
      |> Enum.count()

    [result1: result1, result2: result2]
  end
end

Day17.run("days/inputs/17.txt")
|> IO.inspect()
