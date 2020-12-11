defmodule BagIndex do
  defmodule V1 do
    @moduledoc """
      BagIndex works inside out.
      Inside colors are key, and
      each inside color's outside colors are its value.
    """
    def build(raw_input) do
      raw_input
      |> Stream.map(&extract_colors/1)
      |> Enum.reduce(BagIndex.V1.new(), fn {inside_colors, outside_color}, acc ->
        BagIndex.V1.add(acc, inside_colors, outside_color)
      end)
    end

    def new do
      %{}
    end

    def add(index, inside_colors, outside_color) do
      Enum.reduce(inside_colors, index, fn inside_color, acc ->
        create_key_or_add_to(acc, inside_color, outside_color)
      end)
    end

    # Example input: "muted magenta bags contain 2 clear plum bags."
    # Example output: {"muted magenta", ["clear plum"]}
    defp extract_colors(line) do
      inside_colors = Regex.scan(~r/(?<=\d )\w+ \w+/, line) |> List.flatten()
      [outside_color] = Regex.run(~r/^\w+ \w+/, line)

      {inside_colors, outside_color}
    end

    def recursive_find_outside_colors(index, inside_color, result \\ MapSet.new()) do
      (BagIndex.V1.possible_outside_colors_for(index, inside_color) || [])
      |> Enum.reduce(result, fn color, acc ->
        if color in acc do
          acc
        else
          recursive_find_outside_colors(index, color, MapSet.put(acc, color))
        end
      end)
    end

    def possible_outside_colors_for(index, inside_color) do
      index[inside_color]
    end

    defp create_key_or_add_to(index, inside_color, outside_color) do
      {_orig_value, new_index} =
        Map.get_and_update(index, inside_color, fn current_value ->
          new_value =
            if is_nil(current_value) do
              MapSet.new([outside_color])
            else
              MapSet.put(current_value, outside_color)
            end

          {current_value, new_value}
        end)

      new_index
    end
  end

  defmodule V2 do
    def build(input) do
      input
      |> Stream.map(&extract_key_value/1)
      |> BagIndex.V2.new()
    end

    def new(input) do
      Map.new(input)
    end

    def size(value) do
      Enum.count(value)
    end

    # Example input: "muted magenta bags contain 2 clear plum bags."
    # Example output: {"muted magenta", [{"clear plum", 2}]}
    def extract_key_value(line) do
      [outside] = Regex.run(~r/^\w+ \w+/, line)

      insides =
        Regex.scan(~r/(\d) (\w+ \w+)/, line, capture: :all_but_first)
        |> Enum.map(fn [count_in_str, color] ->
          {color, String.to_integer(count_in_str)}
        end)

      {outside, insides}
    end

    def find_required_bags_count(index, key) do
      recursive_find_required_bags(index, key) - 1
    end

    def recursive_find_required_bags(index, key, result \\ 0) do
      case index[key] do
        [] ->
          1 + result

        insides ->
          1 +
            Enum.reduce(insides, result, fn {color, count}, acc ->
              acc + count * recursive_find_required_bags(index, color)
            end)
      end
    end
  end
end

defmodule Day7 do
  def run(input) do
    sanitized_input =
      input
      |> File.stream!()
      |> Stream.map(&String.trim/1)

    sanitized_input
    |> BagIndex.V1.build()
    |> BagIndex.V1.recursive_find_outside_colors("shiny gold")
    |> MapSet.size()
    |> IO.inspect(label: "Result1")

    sanitized_input
    |> BagIndex.V2.build()
    |> BagIndex.V2.find_required_bags_count("shiny gold")
    |> IO.inspect(label: "Result2")
  end
end
