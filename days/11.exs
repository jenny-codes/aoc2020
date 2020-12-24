defmodule SeatingSystem do
  @moduledoc """
    Each position is either floor (.), an empty seat (L), or an occupied seat (#).
  """
  @empty_seat "L"
  @occupied_seat "#"
  @floor "."

  def build(input) do
    Grid.build(input)
  end

  def run_until_stabalize(grid, ver: ver) do
    adj_map = build_map_of_adjacent_poses(grid, ver: ver)

    run_until_stabalize(grid, adj_map, ver: ver)
  end

  defp run_until_stabalize(grid, adj_map, ver: ver) do
    next_snapshot = iterate(grid, adj_map, ver)

    if next_snapshot == grid do
      grid
    else
      run_until_stabalize(next_snapshot, adj_map, ver: ver)
    end
  end

  def build_map_of_adjacent_poses(grid, ver: version) do
    Grid.map(grid, fn {pos, _val} ->
      {pos, adjacent_poses(grid, pos, ver: version)}
    end)
  end

  defp iterate(grid, adj_map, ver) do
    grid
    |> Grid.map(fn {pos, val} ->
      adj_seat_statuses = adj_map[pos] |> Enum.map(&Grid.fetch(grid, &1))
      new_status = calculate_new_status(val, adj_seat_statuses, ver)
      {pos, new_status}
    end)
  end

  # Rules
  #  If a seat is empty (L) and there are no occupied seats adjacent to it, the seat becomes occupied.
  #  If a seat is occupied (#) and four or more seats adjacent to it are also occupied, the seat becomes empty.
  #  Otherwise, the seat's state does not change.
  defp calculate_new_status(val, adj_seat_statuses, :v1) do
    occupied_adj_seats = Enum.count(adj_seat_statuses, &(&1 == @occupied_seat))

    cond do
      val == @empty_seat and occupied_adj_seats == 0 ->
        @occupied_seat

      val == @occupied_seat and occupied_adj_seats >= 4 ->
        @empty_seat

      true ->
        val
    end
  end

  defp calculate_new_status(val, adj_seat_statuses, :v2) do
    occupied_adj_seats = Enum.count(adj_seat_statuses, &(&1 == @occupied_seat))

    cond do
      val == @empty_seat and occupied_adj_seats == 0 ->
        @occupied_seat

      val == @occupied_seat and occupied_adj_seats >= 5 ->
        @empty_seat

      true ->
        val
    end
  end

  defp adjacent_poses(system, {x_pos, y_pos}, ver: :v1) do
    for x_adj <- [1, 0, -1], y_adj <- [1, 0, -1] do
      {x_pos + x_adj, y_pos + y_adj}
    end
    # Filter out original position
    |> Enum.reject(&(&1 == {x_pos, y_pos || is_out_of_grid(system, &1)}))
  end

  defp adjacent_poses(system, pos, ver: :v2) do
    for x_adj <- [1, 0, -1], y_adj <- [1, 0, -1] do
      {x_adj, y_adj}
    end
    |> Stream.reject(&(&1 == {0, 0}))
    |> Stream.map(&first_seat_in_dir(system, pos, &1))
    |> Enum.reject(&is_nil/1)
  end

  def first_seat_in_dir(system, {x_pos, y_pos}, {x_dir, y_dir}) do
    next_pos = {x_pos + x_dir, y_pos + y_dir}

    case Grid.fetch(system, next_pos) do
      nil -> nil
      @floor -> first_seat_in_dir(system, next_pos, {x_dir, y_dir})
      _ -> next_pos
    end
  end

  def count_occupied(system) do
    system
    |> Grid.values()
    |> Enum.count(&(&1 == @occupied_seat))
  end

  defp is_out_of_grid(system, {x_pos, y_pos}) do
    {x_bond, y_bond} = Grid.boundary(system)
    x_pos < 0 || y_pos < 0 || x_pos > x_bond || y_pos > y_bond
  end
end

defmodule Day11 do
  def run(input_path) do
    seating_system =
      input_path
      |> FileUtil.parse()
      |> Stream.map(&String.split(&1, "", trim: true))
      |> SeatingSystem.build()

    result1 =
      seating_system
      |> SeatingSystem.run_until_stabalize(ver: :v1)
      |> SeatingSystem.count_occupied()

    result2 =
      seating_system
      |> SeatingSystem.run_until_stabalize(ver: :v2)
      |> SeatingSystem.count_occupied()

    [part1: result1, part2: result2]
  end
end

Day11.run("days/inputs/11.txt")
|> IO.inspect()
