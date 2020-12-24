defmodule StepBm do
  def run_with_test_data do
    input =
      FileUtil.parse("days/inputs/10_test.txt")
      |> EnumUtil.transform_element(Integer, lazy: true)
      |> Enum.sort()

    Benchee.run(
      %{
        "recursive" => fn -> Step.run_recursive(input, 3) end,
        "recursive optimized" => fn -> Step.run_recursive_optimized(input, 3) end,
        "with difference" => fn -> Step.run_with_difference(input, 3) end,
        "with difference optimized" => fn -> Step.run_with_difference_optimized(input, 3) end,
        "concurrent" => fn -> Step.run_concurrent(input, 3) end
      },
      time: 10
    )
  end

  # The naive recursive implementation will run for hours so here we only compare
  # the two difference implementations.
  def run do
    input =
      FileUtil.parse("days/inputs/10.txt")
      |> EnumUtil.transform_element(Integer, lazy: true)
      |> Enum.sort()

    Benchee.run(
      %{
        "with difference" => fn -> Step.run_with_difference(input, 3) end,
        "with difference optimized" => fn -> Step.run_with_difference_optimized(input, 3) end
      },
      time: 10
    )
  end
end

StepBm.run_larger_data()
