require "spec_helper"
require "generated/parser"

describe Parser do
  it "parses strings" do
    tested = %{"Hello"\n"World"}
    expected = Nodes.new([StringNode.new("Hello"), StringNode.new("World")])
    expect(Parser.new.parse(tested)).to eq(expected)
  end

  it "parses set expression" do
    tested = "x = \"Hello World\""
    expected = Nodes.new([SetNode.new("x", StringNode.new("Hello World"))])
    expect(Parser.new.parse(tested)).to eq(expected)
  end

  it "parses set expression with block" do
    tested = "x =\n  \"Hello World\""
    expected = Nodes.new([
      SetNode.new(
        "x",
        Nodes.new([StringNode.new("Hello World")])
      )
    ])
    expect(Parser.new.parse(tested)).to eq(expected)
  end

  it "parses get expression" do
    tested = "x"
    expected = Nodes.new([GetNode.new("x")])
    expect(Parser.new.parse(tested)).to eq(expected)
  end

  it "parses namespaced get expression" do
    tested = "namespace1.namespace2.name"
    expected = Nodes.new([
      HashGetNode.new(
        "name",
        HashGetNode.new(
          "namespace2",
          GetNode.new("namespace1")
        )
      )
    ])
    expect(Parser.new.parse(tested)).to eq(expected)
  end

  describe "array" do
    it "parses arrays" do
      tested = "[x, y, \"asd\"]"
      expected = Nodes.new([
        Nodes.new([
          GetNode.new("x"),
          GetNode.new("y"),
          StringNode.new("asd")
        ])
      ])
      expect(Parser.new.parse(tested)).to eq(expected)
    end

    it "parses an array with single item" do
      tested = "[x]"
      expected = Nodes.new([
        Nodes.new([
          GetNode.new("x")
        ])
      ])
      expect(Parser.new.parse(tested)).to eq(expected)
    end

    it "parses an empty array" do
      tested = "[]"
      expected = Nodes.new([
        Nodes.new([])
      ])
      expect(Parser.new.parse(tested)).to eq(expected)
    end
  end

  describe "function call" do
    it "parses a call with no args" do
      tested = "some_function!"
      expected = Nodes.new([CallNode.new("some_function", nil)])
      expect(Parser.new.parse(tested)).to eq(expected)
    end

    it "parses a call with a block body" do
      tested = "some_function:\n  \"a\""
      expected = Nodes.new([
        CallNode.new("some_function",
          Nodes.new([StringNode.new("a")])
        )
      ])
      expect(Parser.new.parse(tested)).to eq(expected)
    end

    it "parses a call with a single argument" do
      tested = "some_function: \"a\";"
      expected = Nodes.new([
        CallNode.new("some_function",
          Nodes.new([StringNode.new("a")])
        )
      ])
      expect(Parser.new.parse(tested)).to eq(expected)
    end

    it "parses a call witth multiple arguments" do
      tested = "some_function: \"a\", \"b\";"
      expected = Nodes.new([
        CallNode.new("some_function",
          Nodes.new([StringNode.new("a"), StringNode.new("b")])
        )
      ])
      expect(Parser.new.parse(tested)).to eq(expected)
    end
  end

  describe "function definition" do
    it "parses one-expression function definition with no arguments" do
      tested = "[] => print!;"
      expected = Nodes.new([
        DefNode.new(
          Nodes.new([]),
          Nodes.new([CallNode.new('print', nil)])
        )
      ])
      expect(Parser.new.parse(tested)).to eq(expected)
    end

    it "parses multi-expression function definition with no arguments" do
      tested = "[] => print!, print!;"
      expected = Nodes.new([
        DefNode.new(
          Nodes.new([]),
          Nodes.new([CallNode.new('print', nil), CallNode.new('print', nil)])
        )
      ])
      expect(Parser.new.parse(tested)).to eq(expected)
    end

    it "parses function definition with one argument" do
      tested = "[a] => print!, print!;"
      expected = Nodes.new([
        DefNode.new(
          Nodes.new([GetNode.new("a")]),
          Nodes.new([CallNode.new('print', nil), CallNode.new('print', nil)])
        )
      ])
      expect(Parser.new.parse(tested)).to eq(expected)
    end

    it "parses anonymous function definition with multiple arguments" do
      tested = "[a, b] => print!, print!;"
      expected = Nodes.new([
        DefNode.new(
          Nodes.new([GetNode.new("a"), GetNode.new("b")]),
          Nodes.new([CallNode.new('print', nil), CallNode.new('print', nil)])
        )
      ])
      expect(Parser.new.parse(tested)).to eq(expected)
    end

    it "parses anonymous function definition with block body" do
      tested = "[a, b] =>\n  print!"
      expected = Nodes.new([
        DefNode.new(
          Nodes.new([GetNode.new("a"), GetNode.new("b")]),
          Nodes.new([CallNode.new('print', nil)])
        )
      ])
      expect(Parser.new.parse(tested)).to eq(expected)
    end

    it "parses named function definition" do
      tested = "x = [a, b] =>\n  print!"
      expected = Nodes.new([
        SetNode.new(
          "x",
          DefNode.new(
            Nodes.new([GetNode.new("a"), GetNode.new("b")]),
            Nodes.new([CallNode.new('print', nil)])
          )
        )
      ])
      expect(Parser.new.parse(tested)).to eq(expected)
    end
  end
end
