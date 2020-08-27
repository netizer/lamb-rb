require "spec_helper"
require "lexer"

describe Lexer do
  it "creates string tokens" do
    expect(Lexer.new.tokenize('"hi"')).to eq([[:STRING, "hi"]])
  end

  it "creates identifier tokens" do
    expect(Lexer.new.tokenize("name")).to eq([[:IDENTIFIER, "name"]])
  end

  it "creates function definition tokens" do
    expected = [
      ["[", "["],
      ["]", "]"],
      [:ARROW, "=>"],
      [:FUNCTION_CALL_NO_ARGS, "print"]
    ]
    expect(Lexer.new.tokenize("[] => print!")).to eq(expected)
  end

  it "creates namespaced tokens" do
    expected = [
      [:IDENTIFIER, "namespace1.namespace2.name"]
    ]
    expect(Lexer.new.tokenize("namespace1.namespace2.name")).to eq(expected)
  end

  it "creates namespaced tokens for function calls" do
    expected = [
      [:FUNCTION_CALL, "namespace1.namespace2.name"]
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
      [:FUNCTION_CALL, "if"], [:STRING, "1"],
        [:INDENT, 2],
          [:FUNCTION_CALL, "if"], [:STRING, "2"],
          [:INDENT, 4],
            ["(", "("], [:FUNCTION_CALL, "print"], [:STRING, "..."], [")", ")"], [:NEWLINE, "\n"],
            [:FUNCTION_CALL, "if"], [:STRING, "false"],
            [:INDENT, 6],
              [:IDENTIFIER, "pass"],
            [:DEDENT, 4], [:NEWLINE, "\n"],
            [:FUNCTION_CALL, "print"], [:STRING, "done!"],
        [:DEDENT, 2], [:NEWLINE, "\n"],
        [:STRING, "2"],
      [:DEDENT, 0], [:NEWLINE, "\n"],
      [:NEWLINE, "\n"],
      [:FUNCTION_CALL, "print"], [:STRING, "The End"],
      [:NEWLINE, "\n"],
      [:FUNCTION_CALL_NO_ARGS, "print"]
    ]
    expect(Lexer.new.tokenize(code)).to eq(tokens)
  end
end
