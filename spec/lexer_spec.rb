require "spec_helper"
require "lexer"

describe Lexer do
  it "creates string tokens" do
    value = {
      meta: {
        line: 1,
        pos: 1,
      },
      v: "hi"
    }
    expect(Lexer.new.tokenize('"hi"')).to eq([[:STRING, value]])
  end

  it "creates identifier tokens" do
    expected = [[:IDENTIFIER, { v: "name", meta: { line: 1, pos: 1 }}]]
    expect(Lexer.new.tokenize("name")).to eq(expected)
  end

  it "creates function definition tokens" do
    expected = [
      ["[", { v: "[", meta: { line: 1, pos: 1 }}],
      ["]", { v: "]", meta: { line: 1, pos: 2 }}],
      [:ARROW, { v: "=>", meta: { line: 1, pos: 4 }}],
      [:FUNCTION_CALL_NO_ARGS, { v: "print", meta: { line: 1, pos: 7 }}]
    ]
    expect(Lexer.new.tokenize("[] => print!")).to eq(expected)
  end

  it "creates namespaced tokens" do
    meta = { line: 1, pos: 1 }
    expected = [
      [:IDENTIFIER, { v: "namespace1.namespace2.name", meta: meta }]
    ]
    expect(Lexer.new.tokenize("namespace1.namespace2.name")).to eq(expected)
  end

  it "creates namespaced tokens for function calls" do
    meta = { line: 1, pos: 1 }
    expected = [
      [:FUNCTION_CALL, { v: "namespace1.namespace2.name", meta: meta }]
    ]
    expect(Lexer.new.tokenize("namespace1.namespace2.name:")).to eq(expected)
  end

  it "creates indentation tokens" do
    code = <<-CODE
if: "1"
  if: "2"
    ( print: "..." )
    if: "false"
      pass
    print: "done!"
  "2"

print: "The End"
print!
CODE

    tokens = [
      [:FUNCTION_CALL, { v: "if", meta: { line: 1, pos: 1 } }],
      [:STRING, { v: "1", meta: { line: 1, pos: 5 } }],
      [:INDENT, { v: 2, meta: { line: 2, pos: 3 }} ],
      [:FUNCTION_CALL, { v: "if", meta: { line: 2, pos: 3 } }],
      [:STRING, { v: "2", meta: { line: 2, pos: 7 } }],
      [:INDENT, { v: 4, meta: { line: 3, pos: 5 }}],
      ["(", { v: "(", meta: { line: 3, pos: 5 } }],
      [:FUNCTION_CALL, { v: "print", meta: { line: 3, pos: 7 } }],
      [:STRING, { v: "...", meta: { line: 3, pos: 14 } }],
      [")", { v: ")", meta: { line: 3, pos: 20 } }],
      [:NEWLINE, { v: "\n", meta: { line: 3, pos: 21 } }],
      [:FUNCTION_CALL, { v: "if", meta: { line: 4, pos: 5 } }],
      [:STRING, { v: "false", meta: { line: 4, pos: 9 } }],
      [:INDENT, { v: 6, meta: { line: 5, pos: 7 }}],
      [:IDENTIFIER, { v: "pass", meta: { line: 5, pos: 7 } }],
      [:DEDENT, { v: 4, meta: { line: 5, pos: 11 }}],
      [:NEWLINE, { v: "\n", meta: { line: 5, pos: 11 } }],
      [:FUNCTION_CALL, { v: "print", meta: { line: 6, pos: 5 } }],
      [:STRING, { v: "done!", meta: { line: 6, pos: 12 } }],
      [:DEDENT, { v: 2, meta: { line: 6, pos: 19 }}],
      [:NEWLINE, { v: "\n", meta: { line: 6, pos: 19 } }],
      [:STRING, { v: "2", meta: { line: 7, pos: 3 } }],
      [:DEDENT, { v: 0, meta: { line: 7, pos: 6 }}],
      [:NEWLINE, { v: "\n", meta: { line: 7, pos: 6 } }],
      [:NEWLINE, { v: "\n", meta: { line: 8, pos: 1 } }],
      [:FUNCTION_CALL, { v: "print", meta: { line: 9, pos: 1 } }],
      [:STRING, { v: "The End", meta: { line: 9, pos: 8 } }],
      [:NEWLINE, { v: "\n", meta: { line: 9, pos: 17 } }],
      [:FUNCTION_CALL_NO_ARGS, { v: "print", meta: { line: 10, pos: 1 } }]
    ]
    expect(Lexer.new.tokenize(code)).to eq(tokens)
  end
end
