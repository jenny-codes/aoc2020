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

    new_mem = Map.put(mem, loc, new_val)

    Map.put(memo, :mem, new_mem)
  end

  defp apply_mask(val, mask) do
    [val, mask]
    |> Enum.map(&String.split(&1, "", trim: true))
    |> add_leading_zeros_for_mask
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

  defp add_leading_zeros_for_mask([val, mask]) do
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
end

defmodule Day14 do
  def run(input_path) do
    memo =
      Util.parse_file(input_path, to: :list)
      |> BitMask.V1.run()

    memo[:mem]
    |> Map.values()
    |> Enum.sum()
  end
end

Day14.run("days/inputs/14.txt")
|> IO.inspect()
