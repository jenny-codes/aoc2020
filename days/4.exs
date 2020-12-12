defmodule Passport do
  def new(args) do
    Map.new(args)
  end

  def is_valid?(passport, strict: false) do
    map_size(passport) == 8 || (map_size(passport) == 7 && is_nil(passport[:cid]))
  end

  def is_valid?(passport, strict: true) do
    with true <- is_valid?(passport, strict: false),
         true <- has_valid_byr?(passport),
         true <- has_valid_iyr?(passport),
         true <- has_valid_eyr?(passport),
         true <- has_valid_hgt?(passport),
         true <- has_valid_hcl?(passport),
         true <- has_valid_ecl?(passport),
         true <- has_valid_pid?(passport) do
      true
    else
      _ -> false
    end
  end

  # (Birth Year) - four digits; at least 1920 and at most 2002.
  defp has_valid_byr?(%{byr: byr}) do
    if {num, ""} = Integer.parse(byr) do
      1920 <= num and num <= 2002
    else
      false
    end
  end

  # (Issue Year) - four digits; at least 2010 and at most 2020.
  defp has_valid_iyr?(%{iyr: iyr}) do
    if {num, ""} = Integer.parse(iyr) do
      2010 <= num and num <= 2020
    else
      false
    end
  end

  # (Expiration Year) - four digits; at least 2020 and at most 2030.
  defp has_valid_eyr?(%{eyr: eyr}) do
    if {num, ""} = Integer.parse(eyr) do
      2020 <= num and num <= 2030
    else
      false
    end
  end

  # (Height) - a number followed by either cm or in:
  #  If cm, the number must be at least 150 and at most 193.
  #  If in, the number must be at least 59 and at most 76.
  defp has_valid_hgt?(%{hgt: hgt}) do
    case Integer.parse(hgt) do
      {num, "cm"} -> 150 <= num and num <= 193
      {num, "in"} -> 59 <= num and num <= 76
      _ -> false
    end
  end

  # (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
  defp has_valid_hcl?(%{hcl: hcl}) do
    Regex.match?(~r/^#[0-9a-f]{6}$/, hcl)
  end

  # (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
  defp has_valid_ecl?(%{ecl: ecl}) do
    ecl in ~w(amb blu brn gry grn hzl oth)
  end

  # (Passport ID) - a nine-digit number, including leading zeroes.
  defp has_valid_pid?(%{pid: pid}) do
    Regex.match?(~r/^\d{9}$/, pid)
  end
end

defmodule Day4 do
  def run(input) do
    passports =
      input
      |> File.stream!()
      |> Stream.map(&String.trim/1)
      |> parse_to_passports

    passports
    |> Enum.filter(&Passport.is_valid?(&1, strict: false))
    |> Enum.count()
    |> IO.inspect(label: "Result1")

    passports
    |> Enum.filter(&Passport.is_valid?(&1, strict: true))
    |> Enum.count()
    |> IO.inspect(label: "Result2")
  end

  defp parse_to_passports(input) do
    Enum.reduce(input, [], fn line, acc ->
      if line == "" do
        [[] | acc]
      else
        [record | tail] = acc

        new_fields =
          line
          |> String.split(" ", trim: true)
          |> Enum.map(&normalize_passport_field/1)

        [new_fields ++ record | tail]
      end
    end)
    |> Enum.map(&Passport.new/1)
  end

  @doc """
    Example input: "hcl:#341e13"
    Example output: {:hcl, "#341e13"}
  """
  def normalize_passport_field(str) do
    %{"key" => key, "value" => value} = Regex.named_captures(~r/(?<key>\w+):(?<value>.+)/, str)

    {String.to_atom(key), value}
  end
end

Day4.run("days/inputs/4.txt")
