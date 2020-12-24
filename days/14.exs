defmodule BitMask.V1 do
  def run(insts) do
    Enum.reduce(insts, %{mask: nil, mem: %{}}, &run_inst/2)
  end

  def run_inst(inst, memo) do
    if String.starts_with?(inst, "mask") do
      update_mask(inst, memo)
    else
      update_mem(inst, memo)
    end
  end

  defp update_mask(inst, memo) do
    [new_mask] = Regex.run(~r/mask = (\w+)/, inst, capture: :all_but_first)

    Map.put(memo, :mask, new_mask)
  end

  defp update_mem(inst, %{mask: mask, mem: mem} = memo) do
    %{"loc" => loc, "val" => val} =
      Regex.named_captures(~r/mem\[(?<loc>\d+)\] = (?<val>\d+)/, inst)

    new_val =
      val
      |> String.to_integer()
      |> MathUtil.BaseConverter.to_base2()
      |> Integer.to_string()
      |> apply_mask(mask)
      |> MathUtil.BaseConverter.from_base2()
      |> Integer.to_string()

    new_mem = Map.put(mem, loc, new_val)

    Map.put(memo, :mem, new_mem)
  end

  defp apply_mask(val, mask) do
    [val, mask]
    |> Enum.map(&String.split(&1, "", trim: true))
    |> add_leading_zeros_to_match
    |> Stream.zip()
    |> Enum.map(fn {v, m} ->
      if m == "X" do
        v
      else
        m
      end
    end)
    |> Enum.join()
    |> String.to_integer()
  end

  defp add_leading_zeros_to_match([val, mask]) do
    new_val =
      1..(Enum.count(mask) - Enum.count(val))
      |> Enum.reduce(val, fn _, memo ->
        ["0" | memo]
      end)

    [new_val, mask]
  end
end

defmodule BitMask.V2 do
  def run(insts) do
    Enum.reduce(insts, %{mask: nil, mem: %{}}, &run_inst/2)
  end

  def run_inst(inst, memo) do
    if String.starts_with?(inst, "mask") do
      update_mask(inst, memo)
    else
      update_mem(inst, memo)
    end
  end

  defp update_mask(inst, memo) do
    [new_mask] = Regex.run(~r/mask = (\w+)/, inst, capture: :all_but_first)

    Map.put(memo, :mask, new_mask)
  end

  defp update_mem(inst, %{mask: mask, mem: mem} = memo) do
    %{"loc" => loc, "val" => val} =
      Regex.named_captures(~r/mem\[(?<loc>\d+)\] = (?<val>\d+)/, inst)

    new_locs =
      loc
      |> String.to_integer()
      |> MathUtil.BaseConverter.to_base2()
      |> Integer.to_string()
      |> apply_mask(mask)

    new_mem =
      new_locs
      |> Enum.reduce(mem, fn loc, acc ->
        Map.put(acc, loc, val)
      end)

    Map.put(memo, :mem, new_mem)
  end

  # If the bitmask bit is 0, the corresponding memory address bit is unchanged.
  # If the bitmask bit is 1, the corresponding memory address bit is overwritten with 1.
  # If the bitmask bit is X, the corresponding memory address bit is floating.
  defp apply_mask(loc, mask) do
    [loc, mask]
    |> Enum.map(&String.split(&1, "", trim: true))
    |> add_leading_zeros_to_match
    |> Enum.zip()
    |> process_locs()
    |> List.flatten()
  end

  defp process_locs(bits, curr_str \\ "")

  defp process_locs([], curr_str) do
    curr_str
  end

  defp process_locs([{loc_bit, msk_bit} | bits], curr_str) do
    case msk_bit do
      "0" -> process_locs(bits, curr_str <> loc_bit)
      "1" -> process_locs(bits, curr_str <> "1")
      "X" -> [process_locs(bits, curr_str <> "0"), process_locs(bits, curr_str <> "1")]
    end
  end

  defp add_leading_zeros_to_match([val, mask]) do
    new_val =
      1..(Enum.count(mask) - Enum.count(val))
      |> Enum.reduce(val, fn _, memo ->
        ["0" | memo]
      end)

    [new_val, mask]
  end
end

defmodule Day14 do
  def run(input_path) do
    input = FileUtil.parse(input_path)
    result1 = process_answer(input, BitMask.V1)
    result2 = process_answer(input, BitMask.V2)

    [result1: result1, result2: result2]
  end

  defp process_answer(input, module) do
    memo = module.run(input)

    memo[:mem]
    |> Map.values()
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end
end

Day14.run("days/inputs/14.txt")
|> IO.inspect()
