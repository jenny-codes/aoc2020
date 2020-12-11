defmodule Day2 do
  def run(input) do
    formatted_input =
      input
      |> File.stream!()
      |> Stream.map(&String.trim/1)
      |> Stream.map(&parse/1)

    formatted_input
    |> Stream.filter(&validate1/1)
    |> Enum.count()
    |> IO.inspect(label: "result1")

    formatted_input
    |> Stream.filter(&validate2/1)
    |> Enum.count()
    |> IO.inspect(label: "result2")
  end

  defp parse(raw_str) do
    # Format: "1-4 j: jjjqzmgbjwpj"
    normalize = fn %{"first_int" => first, "second_int" => second} = item ->
      item
      |> Map.put("first_int", first |> String.to_integer())
      |> Map.put("second_int", second |> String.to_integer())
    end

    ~r/(?<first_int>\d+)-(?<second_int>\d+) (?<char>\w): (?<text>\w*)$/
    |> Regex.named_captures(raw_str)
    |> normalize.()
  end

  defp validate1(%{"first_int" => min, "second_int" => max, "char" => char, "text" => text}) do
    valid_range = min..max

    char_count =
      text
      |> String.split(char)
      |> Enum.count()
      |> (fn x -> x - 1 end).()

    char_count in valid_range
  end

  defp validate2(%{"first_int" => pos1, "second_int" => pos2, "char" => char, "text" => text}) do
    false
    |> toggle_if(String.at(text, pos1 - 1) == char)
    |> toggle_if(String.at(text, pos2 - 1) == char)
  end

  defp toggle_if(value, condition) do
    if condition do
      !value
    else
      value
    end
  end
end
