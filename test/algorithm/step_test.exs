defmodule StepTest do
  use ExUnit.Case
  doctest Step

  test "it runs correctly" do
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

    result = Step.run_with_difference_optimized(input, 3)

    assert result == 19208
  end
end
