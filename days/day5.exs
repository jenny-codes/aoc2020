defmodule BoardingPass do
  @doc """
    Example input: "FFFFBBFLLR"
    Example output: a number between 1 and 128 * 8 (2^10)
  """
  def calculate_seat_id(pass) do
    pass
    |> String.split("", trim: true)
    |> Enum.reverse()
    |> calculate_seat_id(0, 0)
  end

  defp calculate_seat_id([], acc, _curr_digit), do: acc

  defp calculate_seat_id([curr_char | tail], acc, curr_digit) do
    value =
      if curr_char == "R" || curr_char == "B" do
        (:math.pow(2, curr_digit) * 1)
        |> round()
      else
        0
      end

    calculate_seat_id(tail, acc + value, curr_digit + 1)
  end

  def is_first_row?(seat_id) do
    seat_id >= 0 and seat_id <= 7
  end

  def is_last_row?(seat_id) do
    seat_id >= 1016 and seat_id <= 1023
  end
end

defmodule Day5 do
  def run(input) do
    seat_ids =
      input
      |> File.stream!()
      |> Stream.map(&String.trim/1)
      |> Stream.map(&BoardingPass.calculate_seat_id/1)

    seat_ids
    |> Enum.max()
    |> IO.inspect(label: "Result1")

    seat_ids
    |> Stream.reject(fn seat_id ->
      BoardingPass.is_first_row?(seat_id) || BoardingPass.is_last_row?(seat_id)
    end)
    |> find_missing_num()
    |> IO.inspect(label: "Result2")
  end

  defp find_missing_num(seat_ids) do
    min = Enum.min(seat_ids)
    max = Enum.max(seat_ids)

    [missing_num] = Enum.reject(min..max, fn i ->
      i in seat_ids
    end)

    missing_num
  end
end

Day5.run("days/inputs/day5.txt")
