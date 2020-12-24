defmodule Navigator do
  @north "N"
  @south "S"
  @east "E"
  @west "W"
  @left "L"
  @right "R"
  @forward "F"

  @move_vectors %{
    @north => {0, 1},
    @south => {0, -1},
    @east => {1, 0},
    @west => {-1, 0}
  }

  @turn_vectors %{
    @left => -1,
    @right => 1
  }

  def build_instructions(input) do
    Enum.map(input, &parse_str_to_inst/1)
  end

  def run_instructions(inst_list, init_pos, init_dir, ver: :v1) do
    init_waypoint_vec = @move_vectors[init_dir]

    Enum.reduce(inst_list, {init_pos, init_waypoint_vec}, fn {action, val}, {pos, waypoint_vec} ->
      cond do
        is_move(action) ->
          {move(pos, @move_vectors[action], val), waypoint_vec}

        is_turn(action) ->
          {pos, rotate(waypoint_vec, @turn_vectors[action], val)}

        is_forward(action) ->
          {move(pos, waypoint_vec, val), waypoint_vec}
      end
    end)
  end

  def run_instructions(inst_list, init_pos, init_waypoint_vec, ver: :v2) do
    Enum.reduce(inst_list, {init_pos, init_waypoint_vec}, fn {action, val}, {pos, waypoint_vec} ->
      cond do
        is_move(action) ->
          {pos, move(waypoint_vec, @move_vectors[action], val)}

        is_turn(action) ->
          {pos, rotate(waypoint_vec, @turn_vectors[action], val)}

        is_forward(action) ->
          {move(pos, waypoint_vec, val), waypoint_vec}
      end
    end)
  end

  defp is_move(action) do
    action in Map.keys(@move_vectors)
  end

  defp is_turn(action) do
    action in Map.keys(@turn_vectors)
  end

  defp is_forward(action) do
    action == @forward
  end

  defp move({pos_x, pos_y}, {dir_x, dir_y}, vol) do
    {pos_x + dir_x * vol, pos_y + dir_y * vol}
  end

  defp rotate({pos_x, pos_y}, turn_vec, angle) do
    normalized_angle =
      if turn_vec < 0 do
        turn_vec * angle + 360
      else
        angle
      end
      |> rem(360)
      |> round

    case normalized_angle do
      0 -> {pos_x, pos_y}
      90 -> {pos_y, -pos_x}
      180 -> {-pos_x, -pos_y}
      270 -> {-pos_y, pos_x}
    end
  end

  defp parse_str_to_inst(str) do
    [action, value_in_str] =
      Regex.scan(~r/^(\w)(\d*)$/, str, capture: :all_but_first)
      |> List.flatten()

    {action, String.to_integer(value_in_str)}
  end
end

defmodule Day12 do
  def run(file_path) do
    inst_list =
      file_path
      |> FileUtil.parse()
      |> Navigator.build_instructions()

    {end_pos_v1, _} = Navigator.run_instructions(inst_list, {0, 0}, "E", ver: :v1)
    {end_pos_v2, _} = Navigator.run_instructions(inst_list, {0, 0}, {10, 1}, ver: :v2)

    result1 = abs(elem(end_pos_v1, 0) + elem(end_pos_v1, 1))
    result2 = abs(elem(end_pos_v2, 0) + elem(end_pos_v2, 1))

    [result1: result1, result2: result2]
  end
end

Day12.run("days/inputs/12.txt")
|> IO.inspect()
