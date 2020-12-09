defmodule BootCode do
  def build(instructions) do
    instructions
    |> Stream.map(&parse/1)
    |> Stream.with_index()
    |> new
  end

  def run_v1(code) do
    run_v1(code, 0, 0)
  end

  defp run_v1(code, ptr, acc) do
    next_code = remove_inst(code, ptr)

    case code[ptr] do
      nil -> acc
      {"acc", arg} -> run_v1(next_code, ptr + 1, acc + arg)
      {"jmp", arg} -> run_v1(next_code, ptr + arg, acc)
      {"nop", _arg} -> run_v1(next_code, ptr + 1, acc)
    end
  end

  @doc """
  For operation :jmp and :nop
    If this is not the main branch, don't branch out again.
    If this the main branch, then do a branch out (and mark it a branch).
  """
  def run_v2(code) do
    destination = map_size(code)
    run_v2(code, false, destination, 0, 0)
  end

  defp run_v2(_code, _is_branched, dest, ptr, acc) when dest == ptr, do: acc

  defp run_v2(code, is_branch, dest, ptr, acc) do
    # IO.inspect(ptr, label: "ptr")
    # IO.inspect(code[ptr], label: "operation")
    next_code = remove_inst(code, ptr)

    case code[ptr] do
      nil ->
        IO.puts("Ended one branch.")
        nil

      {"acc", arg} ->
        run_v2(next_code, is_branch, dest, ptr + 1, acc + arg)

      {"jmp", arg} ->
        if is_branch do
          run_v2(next_code, is_branch, dest, ptr + arg, acc)
        else
          run_v2(next_code, false, dest, ptr + arg, acc) ||
            run_v2(next_code, true, dest, ptr + 1, acc)
        end

      {"nop", arg} ->
        if is_branch do
          run_v2(next_code, is_branch, dest, ptr + 1, acc)
        else
          run_v2(next_code, false, dest, ptr + 1, acc) ||
            run_v2(next_code, true, dest, ptr + arg, acc)
        end
    end
  end

  defp new(indexed_instructions) do
    Map.new(indexed_instructions, fn {v, k} -> {k, v} end)
  end

  defp parse(instruction) do
    normalize = fn [operation, argument_in_str] ->
      {operation, String.to_integer(argument_in_str)}
    end

    instruction
    |> String.split(" ")
    |> normalize.()
  end

  defp remove_inst(code, inst_key) do
    Map.delete(code, inst_key)
  end
end

defmodule Day8 do
  def run(input) do
    sanitized_input =
      input
      |> File.stream!()
      |> Stream.map(&String.trim/1)

    sanitized_input
    |> BootCode.build()
    |> BootCode.run_v1()
    |> IO.inspect(label: "Result1")

    sanitized_input
    |> BootCode.build()
    |> BootCode.run_v2()
    |> IO.inspect(label: "Result2")
  end
end

Day8.run("days/inputs/day8.txt")
