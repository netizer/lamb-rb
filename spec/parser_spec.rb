require "spec_helper"
require "generated/parser"

describe Parser do
  it "parses strings" do
    tested = %{"Hello"\n"World"}
    expected = Nodes.new([
      StringNode.new({ v: "Hello", meta: { line: 1, pos: 1}}),
      StringNode.new({ v: "World", meta: { line: 2, pos: 1 }})
    ])
    expect(Parser.new.parse(tested)).to eq(expected)
  end

  it "parses set expression" do
    tested = "x = \"Hello World\""
    expected = Nodes.new([
      SetNode.new(
        { v: "x", meta: { line: 1, pos: 1 }},
        StringNode.new({ v: "Hello World", meta: { line: 1, pos: 5 }})
      )
    ])
    expect(Parser.new.parse(tested)).to eq(expected)
  end

  it "parses set expression with block" do
    tested = "x =\n  \"Hello World\""
    expected = Nodes.new([
      SetNode.new(
        { v: "x", meta: { line: 1, pos: 1 }},
        Nodes.new([
          StringNode.new({ v: "Hello World", meta: { line: 2, pos: 3 }})
        ])
      )
    ])
    expect(Parser.new.parse(tested)).to eq(expected)
  end

  it "parses get expression" do
    tested = "x"
    expected = Nodes.new([GetNode.new({ v: "x", meta: { line: 1, pos: 1 } })])
    expect(Parser.new.parse(tested)).to eq(expected)
  end

  it "parses namespaced get expression" do
    tested = "namespace1.namespace2.name"
    expected = Nodes.new([
      GetNode.new({ v: "namespace1.namespace2.name", meta: { line: 1, pos: 1 } })
    ])
    expect(Parser.new.parse(tested)).to eq(expected)
  end

  describe "array" do
    it "parses arrays" do
      tested = "[x, y, \"asd\"]"
      expected = Nodes.new([
        Nodes.new([
          GetNode.new({ v: "x", meta: { line: 1, pos: 2 } }),
          GetNode.new({ v: "y", meta: { line: 1, pos: 5 } }),
          StringNode.new({ v: "asd", meta: { line: 1, pos: 8 } })
        ])
      ])
      expect(Parser.new.parse(tested)).to eq(expected)
    end

    it "parses an array with single item" do
      tested = "[x]"
      expected = Nodes.new([
        Nodes.new([
          GetNode.new({ v: "x", meta: { line: 1, pos: 2 } })
        ])
      ])
      expect(Parser.new.parse(tested)).to eq(expected)
    end

    it "parses an empty array" do
      tested = "[]"
      expected = Nodes.new([
        Nodes.new([], { line: 1, pos: 1 })
      ])
      expect(Parser.new.parse(tested)).to eq(expected)
    end
  end

  describe "function call" do
    it "parses a call with no args" do
      tested = "some_function!"
      expected = Nodes.new([
        CallNode.new({ v: "some_function", meta: { line: 1, pos: 1 } }, nil)
      ])
      expect(Parser.new.parse(tested)).to eq(expected)
    end

    it "parses a call with a block body" do
      tested = "some_function:\n  \"a\""
      expected = Nodes.new([
        CallNode.new({ v: "some_function", meta: { line: 1, pos: 1 } },
          Nodes.new([StringNode.new({ v: "a", meta: { line: 2, pos: 3} })])
        )
      ])
      expect(Parser.new.parse(tested)).to eq(expected)
    end

    it "parses a call with a single argument" do
      tested = "some_function: \"a\""
      expected = Nodes.new([
        CallNode.new({ v: "some_function", meta: { line: 1, pos: 1 } },
          Nodes.new([StringNode.new({ v: "a", meta: { line: 1, pos: 16 } })])
        )
      ])
      expect(Parser.new.parse(tested)).to eq(expected)
    end

    it "parses a call witth multiple arguments" do
      tested = "some_function: \"a\", \"b\""
      expected = Nodes.new([
        CallNode.new({ v: "some_function", meta: { line: 1, pos: 1 } },
          Nodes.new([
            StringNode.new({ v: "a", meta: { line: 1, pos: 16 } }),
            StringNode.new({ v: "b", meta: { line: 1, pos: 21 } })
          ])
        )
      ])
      expect(Parser.new.parse(tested)).to eq(expected)
    end

    it "parses namespaced calls" do
      tested = "namespace.some_function: \"a\", \"b\""
      expected = Nodes.new([
        CallNode.new({ v: "namespace.some_function", meta: { line: 1, pos: 1 } },
          Nodes.new([
            StringNode.new({ v: "a", meta: { line: 1, pos: 26 } }),
            StringNode.new({ v: "b", meta: { line: 1, pos: 31 } })
          ])
        )
      ])
      expect(Parser.new.parse(tested)).to eq(expected)
    end
  end

  describe "function definition" do
    it "parses one-expression function definition with no arguments" do
      tested = "[] => print!"
      expected = Nodes.new([
        DefNode.new(
          Nodes.new([], { line: 1, pos: 1 }),
          Nodes.new([
            CallNode.new(
              { v: 'print', meta: { line: 1, pos: 7 } },
              nil
            )
          ])
        )
      ])
      expect(Parser.new.parse(tested)).to eq(expected)
    end

    it "parses multi-expression function definition with no arguments" do
      tested = "[] => print!, print!"
      expected = Nodes.new([
        DefNode.new(
          Nodes.new([], { line: 1, pos: 1}),
          Nodes.new([
            CallNode.new({ v: 'print', meta: { line: 1, pos: 7 } }, nil),
            CallNode.new({ v: 'print', meta: { line: 1, pos: 15 } }, nil)
          ])
        )
      ])
      expect(Parser.new.parse(tested)).to eq(expected)
    end

    it "parses function definition with one argument" do
      tested = "[a] => print!, print!"
      expected = Nodes.new([
        DefNode.new(
          Nodes.new([GetNode.new({ v: "a", meta: { line: 1, pos: 2 } })]),
          Nodes.new([
            CallNode.new({ v: 'print', meta: { line: 1, pos: 8 } }, nil),
            CallNode.new({ v: 'print', meta: { line: 1, pos: 16 } }, nil)
          ])
        )
      ])
      expect(Parser.new.parse(tested)).to eq(expected)
    end

    it "parses anonymous function definition with multiple arguments" do
      tested = "[a, b] => print!, print!"
      expected = Nodes.new([
        DefNode.new(
          Nodes.new([
            GetNode.new({ v: "a", meta: { line: 1, pos: 2 } }),
            GetNode.new({ v: "b", meta: { line: 1, pos: 5 } })
          ]),
          Nodes.new([
            CallNode.new({ v: 'print', meta: { line: 1, pos: 11 } }, nil),
            CallNode.new({ v: 'print', meta: { line: 1, pos: 19 } }, nil)
          ])
        )
      ])
      expect(Parser.new.parse(tested)).to eq(expected)
    end

    it "parses anonymous function definition with block body" do
      tested = "[a, b] =>\n  print!"
      expected = Nodes.new([
        DefNode.new(
          Nodes.new([
            GetNode.new({ v: "a", meta: { line: 1, pos: 2 } }),
            GetNode.new({ v: "b", meta: { line: 1, pos: 5 } })
          ]),
          Nodes.new([
            CallNode.new({ v: 'print', meta: { line: 2, pos: 3 } }, nil)
          ])
        )
      ])
      expect(Parser.new.parse(tested)).to eq(expected)
    end

    it "parses named function definition" do
      tested = "x = [a, b] =>\n  print!"
      expected = Nodes.new([
        SetNode.new(
          { v: "x", meta: { line: 1, pos: 1 } },
          DefNode.new(
            Nodes.new([
              GetNode.new({ v: "a", meta: { line: 1, pos: 6 } }),
              GetNode.new({ v: "b", meta: { line: 1, pos: 9 } })
            ]),
            Nodes.new([
              CallNode.new({ v: 'print', meta: { line: 2, pos: 3 } }, nil)
            ])
          )
        )
      ])
      expect(Parser.new.parse(tested)).to eq(expected)
    end
  end
end
