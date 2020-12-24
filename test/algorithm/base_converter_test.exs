defmodule BaseConverterTest do
  use ExUnit.Case
  doctest BaseConverter
  alias BaseConverter

  describe "from_base2" do
    test "by defaults converts num from base2 to base10" do
      assert BaseConverter.from_base2(111) == 7
      assert BaseConverter.from_base2(1111) == 15
      assert BaseConverter.from_base2(11111) == 31
    end

    test "with transform: :list option converts num into list of digits" do
      assert BaseConverter.from_base2(111, transform: :list) == [7]
      assert BaseConverter.from_base2(1111, transform: :list) == [1, 5]
      assert BaseConverter.from_base2(11111, transform: :list) == [3, 1]
    end
  end

  describe "to_base2" do
    test "by defaults converts num from base10 to base2" do
      assert BaseConverter.to_base2(7) == 111
      assert BaseConverter.to_base2(15) == 1111
      assert BaseConverter.to_base2(31) == 11111
    end

    test "with transform: :list option converts num into list of digits" do
      assert BaseConverter.to_base2(7, transform: :list) == [1, 1, 1]
      assert BaseConverter.to_base2(15, transform: :list) == [1, 1, 1, 1]
      assert BaseConverter.to_base2(31, transform: :list) == [1, 1, 1, 1, 1]
    end
  end
end
