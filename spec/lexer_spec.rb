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
    eof_value = {
      meta: {
        line: 1,
        pos: 5
      },
      v: ""
    }
    expect(Lexer.new.tokenize('"hi"')).to eq([
      [:STRING, value],
      [:EOF, eof_value]
    ])
  end

  it "creates identifier tokens" do
    value = {
      meta: {
        line: 1,
        pos: 1,
      },
      v: "name"
    }
    eof_value = {
      meta: {
        line: 1,
        pos: 5
      },
      v: ""
    }
    expected = [
      [:IDENTIFIER, value],
      [:EOF, eof_value]
    ]
    expect(Lexer.new.tokenize("name")).to eq(expected)
  end

  it "creates function definition tokens" do
    expected = [
      ["[", { v: "[", meta: { line: 1, pos: 1 }}],
      ["]", { v: "]", meta: { line: 1, pos: 2 }}],
      [:ARROW, { v: "=>", meta: { line: 1, pos: 4 }}],
      [:FUNCTION_CALL_NO_ARGS, { v: "print", meta: { line: 1, pos: 7 }}],
      [:EOF, { v: "", meta: { line: 1, pos: 13 } }]
    ]
    expect(Lexer.new.tokenize("[] => print!")).to eq(expected)
  end

  it "creates namespaced tokens" do
    meta = { line: 1, pos: 1 }
    eof_meta = { line: 1, pos: 27 }
    expected = [
      [:IDENTIFIER, { v: "namespace1.namespace2.name", meta: meta }],
      [:EOF, { v: "", meta: eof_meta }]
    ]
    expect(Lexer.new.tokenize("namespace1.namespace2.name")).to eq(expected)
  end

  it "creates namespaced tokens for function calls" do
    meta = { line: 1, pos: 1 }
    eof_meta = { line: 1, pos: 28 }
    expected = [
      [:FUNCTION_CALL, { v: "namespace1.namespace2.name", meta: meta }],
      [:EOF, { v: "", meta: eof_meta }]
    ]
    expect(Lexer.new.tokenize("namespace1.namespace2.name:")).to eq(expected)
  end

  it "skips return when it is followed by 2 dots with the same indent" do
    tested = "fun: \"arg1\",\n.. \"arg2\""
    expected = [
      [:FUNCTION_CALL, { meta: { line: 1, pos: 1 }, v: "fun" }],
      [:STRING, { meta: { line: 1, pos: 6 }, v: "arg1" }],
      [",", { meta: { line: 1, pos: 12 }, v: "," }],
      [:STRING, { meta: { line: 2, pos: 4 }, v: "arg2" }],
      [:EOF, { meta: { line: 2, pos: 10 }, v: "" }]
    ]
    expect(Lexer.new.tokenize(tested)).to eq(expected)
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
      [:NEWLINE, {:meta=>{:line=>2, :pos=>3}, :v=>"\n"}],
      [:INDENT, { v: 2, meta: { line: 2, pos: 3 }} ],
      [:FUNCTION_CALL, { v: "if", meta: { line: 2, pos: 3 } }],
      [:STRING, { v: "2", meta: { line: 2, pos: 7 } }],
      [:NEWLINE, {:meta=>{:line=>3, :pos=>5}, :v=>"\n"}],
      [:INDENT, { v: 4, meta: { line: 3, pos: 5 }}],
      ["(", { v: "(", meta: { line: 3, pos: 5 } }],
      [:FUNCTION_CALL, { v: "print", meta: { line: 3, pos: 7 } }],
      [:STRING, { v: "...", meta: { line: 3, pos: 14 } }],
      [")", { v: ")", meta: { line: 3, pos: 20 } }],
      [:NEWLINE, { v: "\n", meta: { line: 3, pos: 21 } }],
      [:FUNCTION_CALL, { v: "if", meta: { line: 4, pos: 5 } }],
      [:STRING, { v: "false", meta: { line: 4, pos: 9 } }],
      [:NEWLINE, {:meta=>{:line=>5, :pos=>7}, :v=>"\n"}],
      [:INDENT, { v: 6, meta: { line: 5, pos: 7 }}],
      [:IDENTIFIER, { v: "pass", meta: { line: 5, pos: 7 } }],
      [:NEWLINE, {:meta=>{:line=>5, :pos=>11}, :v=>"\n"}],
      [:DEDENT, { v: 4, meta: { line: 5, pos: 11 }}],
      [:NEWLINE, { v: "\n", meta: { line: 5, pos: 11 } }],
      [:FUNCTION_CALL, { v: "print", meta: { line: 6, pos: 5 } }],
      [:STRING, { v: "done!", meta: { line: 6, pos: 12 } }],
      [:NEWLINE, {:meta=>{:line=>6, :pos=>19}, :v=>"\n"}],
      [:DEDENT, { v: 2, meta: { line: 6, pos: 19 }}],
      [:NEWLINE, { v: "\n", meta: { line: 6, pos: 19 } }],
      [:STRING, { v: "2", meta: { line: 7, pos: 3 } }],
      [:NEWLINE, {:meta=>{:line=>7, :pos=>6}, :v=>"\n"}],
      [:DEDENT, { v: 0, meta: { line: 7, pos: 6 }}],
      [:NEWLINE, { v: "\n", meta: { line: 7, pos: 6 } }],
      [:NEWLINE, { v: "\n", meta: { line: 8, pos: 1 } }],
      [:FUNCTION_CALL, { v: "print", meta: { line: 9, pos: 1 } }],
      [:STRING, { v: "The End", meta: { line: 9, pos: 8 } }],
      [:NEWLINE, { v: "\n", meta: { line: 9, pos: 17 } }],
      [:FUNCTION_CALL_NO_ARGS, { v: "print", meta: { line: 10, pos: 1 } }],
      [:EOF, {:meta=>{:line=>10, :pos=>7}, :v=>""}]
    ]
    expect(Lexer.new.tokenize(code)).to eq(tokens)
  end
end
