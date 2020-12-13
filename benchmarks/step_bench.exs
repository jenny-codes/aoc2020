defmodule StepBenchmark do
  def run do
       input = [
      0,
      1,
      2,
      3,
      4,
      7,
      8,
      9,
      10,
      11,
      14,
      17,
      18,
      19,
      20,
      23,
      24,
      25,
      28,
      31,
      32,
      33,
      34,
      35,
      38,
      39,
      42,
      45,
      46,
      47,
      48,
      49,
      52
    ]


    Benchee.run(%{
      "recursive" => fn -> Step.run_recursive(input, 3) end,
      "recursive optimized" => fn -> Step.run_recursive_optimized(input, 3) end,
      "with difference" => fn -> Step.run_with_difference(input, 3) end,
      "with difference optimized" => fn -> Step.run_with_difference_optimized(input, 3) end,
      "concurrent" => fn -> Step.run_concurrent(input, 3) end,
    }, time: 10)
  end
end

StepBenchmark.run
