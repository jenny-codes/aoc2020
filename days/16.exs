defmodule Ticket do
  defstruct rules: %{}, ur_ticket: nil, nb_tickets: []

  def process(input, output \\ %Ticket{}, section \\ :rules)

  def process([], output, _section), do: output

  def process(["" | input], output, _section) do
    process(input, output, nil)
  end

  def process(["your ticket:" | input], output, _section) do
    process(input, output, :ur_ticket)
  end

  def process(["nearby tickets:" | input], output, _section) do
    process(input, output, :nb_tickets)
  end

  def process([line | input], %Ticket{rules: rules} = output, :rules) do
    [key, range1, range2] =
      Regex.run(~r/(.+): (\d+-\d+) .* (\d+-\d+)/, line, capture: :all_but_first)

    val =
      [range1, range2]
      |> Stream.map(&String.split(&1, "-"))
      |> Stream.map(&EnumUtil.transform_element(&1, Integer, lazy: false))
      |> Stream.map(fn [start, finish] -> start..finish end)
      |> Stream.flat_map(&Enum.to_list/1)
      |> MapSet.new()

    new_rules = Map.put(rules, key, val)

    process(input, %{output | rules: new_rules}, :rules)
  end

  def process([line | input], output, :ur_ticket) do
    val = get_numbers(line)

    process(input, %{output | ur_ticket: val}, nil)
  end

  def process([line | input], %Ticket{nb_tickets: nbt} = output, :nb_tickets) do
    val = get_numbers(line)

    process(input, %{output | nb_tickets: [val | nbt]}, :nb_tickets)
  end

  def match_rules_with_ticket(ticket) do
    ticket.nb_tickets
    |> discard_invalid_tickets(ticket.rules)
    |> group_by_column
    |> Stream.map(&Tuple.to_list/1)
    |> Stream.map(&find_valid_rules(&1, Enum.to_list(ticket.rules)))
    |> EnumUtil.to_indexed_map()
    |> recursive_assign_section
    |> Enum.zip(ticket.ur_ticket)
  end

  defp discard_invalid_tickets(tickets, rules) do
    valid_pool = rules |> Map.values() |> Enum.reduce(&MapSet.union/2)

    Stream.filter(tickets, &is_valid_ticket(&1, valid_pool))
  end

  defp group_by_column(tickets) do
    Stream.zip(tickets)
  end

  defp find_valid_rules(column_nums, rules) do
    rules
    |> Stream.filter(fn {_sec, valid_nums} ->
      Enum.all?(column_nums, &(&1 in valid_nums))
    end)
    |> Stream.map(fn {sec, _vals} -> sec end)
    |> MapSet.new()
  end

  # Steps
  # 1. Find the index with only one section candidate
  # 2. Remove that from all other indice's candidates
  # 3. Run the method aagain, with the values pushed to output
  # 4. When run through, retrun a list sorted by index
  defp recursive_assign_section(sec_candidates, output \\ [])

  defp recursive_assign_section([], output) do
    output
    |> Enum.sort_by(&elem(&1, 0))
    |> Enum.map(&elem(&1, 1))
  end

  defp recursive_assign_section(sec_candidates, output) do
    {idx, chosen_sec} = Enum.find(sec_candidates, fn {_, cands} -> Enum.count(cands) == 1 end)

    sec = chosen_sec |> MapSet.to_list() |> List.first()

    next_sec_candidates =
      sec_candidates
      |> Stream.reject(&(&1 == {idx, chosen_sec}))
      |> Enum.map(fn {idx, cands} ->
        {idx, MapSet.delete(cands, sec)}
      end)

    recursive_assign_section(next_sec_candidates, [{idx, sec} | output])
  end

  defp is_valid_ticket(nums, valid_pool) do
    Enum.all?(nums, fn i -> i in valid_pool end)
  end

  defp get_numbers(str) do
    str
    |> String.split(",", trim: true)
    |> EnumUtil.transform_element(Integer, lazy: false)
  end
end

defmodule Day16 do
  def run(input_path) do
    ticket =
      FileUtil.parse(input_path)
      |> Enum.to_list()
      |> Ticket.process()

    result1 = count_error_rate(ticket)

    result2 =
      ticket
      |> Ticket.match_rules_with_ticket()
      |> sum_departure_values()

    [result1: result1, result2: result2]
  end

  def count_error_rate(ticket) do
    valid_pool = ticket.rules |> Map.values() |> Enum.reduce(&MapSet.union/2)

    candidates = ticket.nb_tickets |> List.flatten()

    candidates
    |> Stream.reject(fn i -> i in valid_pool end)
    |> Enum.sum()
  end

  defp sum_departure_values(rules_w_ur_ticket) do
    rules_w_ur_ticket
    |> Stream.filter(fn {sec, _val} -> String.starts_with?(sec, "departure") end)
    |> Stream.map(&elem(&1, 1))
    |> Enum.reduce(&*/2)
  end
end

Day16.run("days/inputs/16.txt")
|> IO.inspect()
