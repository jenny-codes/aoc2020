defmodule Calculator do
  @operators ["+", "*"]
  def run(inst_str) do
    Regex.scan(~r/(\d+|\+|\*|\(|\))/, inst_str)
    |> Enum.map(&List.first/1)
    |> run([])
  end

  defp run([], [val]), do: val

  defp run(["(" | inst], stack) do
    run(inst, ["(" | stack])
  end

  defp run([")" | inst], [val, _bracket | stack]) do
    run([Integer.to_string(val) | inst], stack)
  end

  defp run(["+" | inst], stack) do
    run(inst, ["+" | stack])
  end

  defp run(["*" | inst], stack) do
    run(inst, ["*" | stack])
  end

  defp run([num_str | inst], stack) do
    num = String.to_integer(num_str)

    if stack == [] || hd(stack) not in @operators do
      run(inst, [num | stack])
    else
      [op, sec_arg | stack] = stack
      run(inst, [evaluate(num, sec_arg, op) | stack])
    end
  end

  defp evaluate(num1, num2, op) do
    case op do
      "+" -> num1 + num2
      "*" -> num1 * num2
    end
  end

  # defp run([val | inst], acc) do
  #   IO.inspect({val, inst, acc}, label: "run")

  #   case val do
  #     "+" ->
  #       {tail, next_val} = resolve_next(inst)
  #       run(tail, acc + next_val)

  #     "*" ->
  #       {tail, next_val} = resolve_next(inst)
  #       run(tail, acc * next_val)

  #     "(" ->
  #       run(inst, 0)

  #     ")" ->
  #       if inst == [] do
  #         acc
  #       else
  #         {inst, acc}
  #       end

  #     num_str ->
  #       run(inst, String.to_integer(num_str))
  #   end
  # end

  # defp resolve_next([val | inst]) do
  #   # IO.inspect({val, inst}, label: "resolve next")

  #   case val do
  #     "(" -> run(inst, 0)
  #     num_str -> {inst, String.to_integer(num_str)}
  #   end
  # end
end

defmodule Calculator.V2 do
  def run(inst_str) do
    Regex.scan(~r/(\d+|\+|\*|\(|\))/, inst_str)
    |> Enum.map(&List.first/1)
    |> run([])
  end

  defp run([], val) do
    val
    |> Enum.filter(&is_number/1)
    |> Enum.reduce(&*/2)
  end

  defp run(["(" | inst], stack) do
    run(inst, ["(" | stack])
  end

  defp run([")" | inst], stack) do
    {new_val, stack} = evaluate_until_opening_bracket(stack)
    run([new_val | inst], stack)
  end

  defp run(["+" | inst], stack) do
    run(inst, ["+" | stack])
  end

  defp run(["*" | inst], stack) do
    run(inst, ["*" | stack])
  end

  defp run([num_str | inst], stack) do
    num =
      if is_number(num_str) do
        num_str
      else
        String.to_integer(num_str)
      end

    case stack do
      ["+" | stack] ->
        [sec_arg | rest] = stack
        run(inst, [num + sec_arg | rest])

      [] ->
        run(inst, [num | stack])

      stack ->
        run(inst, [num | stack])
    end
  end

  defp evaluate_until_opening_bracket(stack) do
    case stack do
      [val, "(" | tail] -> {val, tail}
      [val1, "*", val2 | tail] -> evaluate_until_opening_bracket([val1 * val2 | tail])
    end
  end
end
