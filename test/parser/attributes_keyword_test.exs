defmodule ParserAttributesKeywordTest do
  use ExUnit.Case

  alias Slime.Parser.AttributesKeyword

  doctest AttributesKeyword

  describe "merge/2" do
    test "handles multiple eex nodes" do
      result =
        Slime.Parser.AttributesKeyword.merge(
          [class: "a", class: {:eex, "b"}, class: {:eex, "c"}],
          %{class: " "}
        )

      assert result == [class: {:eex, ~S("a #{b} #{c}")}]
    end

    test "supports custom delimiter" do
      result =
        AttributesKeyword.merge(
          [class: "a", class: "b"],
          %{class: "--"}
        )

      assert result == [class: "a--b"]
    end

    test "leaves unspecified attributes as is" do
      result =
        AttributesKeyword.merge(
          [class: "a", id: "id", class: "b", id: "id1"],
          %{class: " "}
        )

      assert result == [class: "a b", id: "id", id: "id1"]
    end

    test "handles all attributes specified in merge rules" do
      result =
        AttributesKeyword.merge(
          [class: "a", id: "id", class: "b", id: "id1"],
          %{class: " ", id: "+"}
        )

      assert result == [class: "a b", id: "id+id1"]
    end
  end
end
