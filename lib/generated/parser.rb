#
# DO NOT MODIFY!!!!
# This file is automatically generated by Racc 1.5.0
# from Racc grammar file "".
#

require 'racc/parser.rb'

  require "lexer"
  require "nodes"

class Parser < Racc::Parser

module_eval(<<'...end grammar.y/module_eval...', 'grammar.y', 86)
  def parse(code, show_tokens=false)
    @tokens = Lexer.new.tokenize(code) # Tokenize the code using our lexer
    puts @tokens.inspect if show_tokens
    do_parse # Kickoff the parsing process
  end

  def next_token
    @tokens.shift
  end
...end grammar.y/module_eval...
##### State transition tables begin ###

racc_action_table = [
    12,    14,    15,    18,    17,    12,    14,    15,    18,    17,
    11,    36,    12,    13,    16,    11,    23,    12,    13,    16,
    14,    15,    18,    17,    49,    13,    38,    42,    40,    11,
    13,    41,    21,    16,    26,    14,    15,    18,    17,    31,
    14,    15,    18,    17,    11,    30,    19,    38,    16,    11,
    39,    38,    45,    16,    14,    15,    18,    17,   nil,    14,
    15,    18,    17,    11,    30,    40,    46,    16,    11,    40,
    43,   nil,    16,    14,    15,    18,    17,   nil,    14,    15,
    18,    17,    11,   nil,   nil,   nil,    16,    11,   nil,   nil,
   nil,    16,    14,    15,    18,    17,   nil,   nil,   nil,   nil,
   nil,    11,   nil,   nil,   nil,    16 ]

racc_action_check = [
    30,    30,    30,    30,    30,     0,     0,     0,     0,     0,
    30,    22,     2,    30,    30,     0,    15,    44,     0,     0,
    16,    16,    16,    16,    44,     2,    27,    27,    25,    16,
    44,    25,     8,    16,    16,    11,    11,    11,    11,    19,
    18,    18,    18,    18,    11,    18,     1,    24,    11,    18,
    24,    33,    33,    18,    20,    20,    20,    20,   nil,    21,
    21,    21,    21,    20,    21,    34,    34,    20,    21,    28,
    28,   nil,    21,    23,    23,    23,    23,   nil,    38,    38,
    38,    38,    23,   nil,   nil,   nil,    23,    38,   nil,   nil,
   nil,    38,    40,    40,    40,    40,   nil,   nil,   nil,   nil,
   nil,    40,   nil,   nil,   nil,    40 ]

racc_action_pointer = [
     3,    46,    10,   nil,   nil,   nil,   nil,   nil,    25,   nil,
   nil,    32,   nil,   nil,   nil,     5,    17,   nil,    37,    39,
    51,    56,    -2,    70,    33,    14,   nil,    12,    55,   nil,
    -2,   nil,   nil,    37,    51,   nil,   nil,   nil,    75,   nil,
    89,   nil,   nil,   nil,    15,   nil,   nil,   nil,   nil,   nil ]

racc_action_default = [
    -1,   -32,    -2,    -3,    -6,    -7,    -8,    -9,   -10,   -11,
   -12,   -32,   -16,   -17,   -18,   -19,   -32,   -24,   -32,   -32,
    -5,   -32,   -32,   -32,   -32,   -32,   -21,   -32,   -32,   -25,
   -32,    50,    -4,   -32,   -32,   -30,   -13,   -20,   -32,   -22,
   -32,   -23,   -26,   -27,   -32,   -28,   -29,   -14,   -15,   -31 ]

racc_goto_table = [
    20,     2,    25,    22,    28,     1,    29,    34,    24,    35,
    27,   nil,    32,    33,   nil,    37,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
    47,    44,    48,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,    20 ]

racc_goto_check = [
     4,     2,    11,     3,    11,     1,    12,    11,     3,    12,
     3,   nil,     3,     3,   nil,     3,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
     3,     2,     3,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,     4 ]

racc_goto_pointer = [
   nil,     5,     1,    -8,    -2,   nil,   nil,   nil,   nil,   nil,
   nil,   -14,   -12 ]

racc_goto_default = [
   nil,   nil,   nil,     3,     4,     5,     6,     7,     8,     9,
    10,   nil,   nil ]

racc_reduce_table = [
  0, 0, :racc_error,
  0, 19, :_reduce_1,
  1, 19, :_reduce_2,
  1, 20, :_reduce_3,
  3, 20, :_reduce_4,
  2, 20, :_reduce_5,
  1, 20, :_reduce_6,
  1, 21, :_reduce_none,
  1, 21, :_reduce_none,
  1, 21, :_reduce_none,
  1, 21, :_reduce_none,
  1, 21, :_reduce_none,
  1, 21, :_reduce_none,
  3, 21, :_reduce_13,
  3, 29, :_reduce_14,
  3, 29, :_reduce_15,
  1, 22, :_reduce_none,
  1, 22, :_reduce_none,
  1, 23, :_reduce_18,
  1, 24, :_reduce_19,
  3, 25, :_reduce_20,
  2, 26, :_reduce_21,
  3, 26, :_reduce_22,
  3, 26, :_reduce_23,
  1, 27, :_reduce_24,
  2, 27, :_reduce_25,
  3, 27, :_reduce_26,
  3, 27, :_reduce_27,
  4, 28, :_reduce_28,
  4, 28, :_reduce_29,
  3, 28, :_reduce_30,
  3, 30, :_reduce_31 ]

racc_reduce_n = 32

racc_shift_n = 50

racc_token_table = {
  false => 0,
  :error => 1,
  :NEWLINE => 2,
  :STRING => 3,
  :IDENTIFIER => 4,
  :FUNCTION_CALL => 5,
  :FUNCTION_CALL_NO_ARGS => 6,
  :ARROW => 7,
  :INDENT => 8,
  :DEDENT => 9,
  "=>" => 10,
  "=" => 11,
  "(" => 12,
  ")" => 13,
  "," => 14,
  ";" => 15,
  "[" => 16,
  "]" => 17 }

racc_nt_base = 18

racc_use_result_var = true

Racc_arg = [
  racc_action_table,
  racc_action_check,
  racc_action_default,
  racc_action_pointer,
  racc_goto_table,
  racc_goto_check,
  racc_goto_default,
  racc_goto_pointer,
  racc_nt_base,
  racc_reduce_table,
  racc_token_table,
  racc_shift_n,
  racc_reduce_n,
  racc_use_result_var ]

Racc_token_to_s_table = [
  "$end",
  "error",
  "NEWLINE",
  "STRING",
  "IDENTIFIER",
  "FUNCTION_CALL",
  "FUNCTION_CALL_NO_ARGS",
  "ARROW",
  "INDENT",
  "DEDENT",
  "\"=>\"",
  "\"=\"",
  "\"(\"",
  "\")\"",
  "\",\"",
  "\";\"",
  "\"[\"",
  "\"]\"",
  "$start",
  "Program",
  "Expressions",
  "Expression",
  "Terminator",
  "Literal",
  "Get",
  "Set",
  "Array",
  "Call",
  "Def",
  "CommaSeparatedItems",
  "Block" ]

Racc_debug_parser = false

##### State transition tables end #####

# reduce 0 omitted

module_eval(<<'.,.,', 'grammar.y', 17)
  def _reduce_1(val, _values, result)
     result = Nodes.new([])
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 18)
  def _reduce_2(val, _values, result)
     result = val[0]
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 22)
  def _reduce_3(val, _values, result)
     result = Nodes.new(val)
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 23)
  def _reduce_4(val, _values, result)
     result = val[0] << val[2]
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 24)
  def _reduce_5(val, _values, result)
     result = val[0]
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 25)
  def _reduce_6(val, _values, result)
     result = Nodes.new([])
    result
  end
.,.,

# reduce 7 omitted

# reduce 8 omitted

# reduce 9 omitted

# reduce 10 omitted

# reduce 11 omitted

# reduce 12 omitted

module_eval(<<'.,.,', 'grammar.y', 35)
  def _reduce_13(val, _values, result)
     result = val[1]
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 39)
  def _reduce_14(val, _values, result)
     result = Nodes.new([val[0], val[2]])
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 40)
  def _reduce_15(val, _values, result)
     result = val[0] << val[2]
    result
  end
.,.,

# reduce 16 omitted

# reduce 17 omitted

module_eval(<<'.,.,', 'grammar.y', 48)
  def _reduce_18(val, _values, result)
     result = StringNode.new(val[0])
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 52)
  def _reduce_19(val, _values, result)
     result = GetNode.new(val[0])
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 56)
  def _reduce_20(val, _values, result)
     result = SetNode.new(val[0], val[2])
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 60)
  def _reduce_21(val, _values, result)
     result = Nodes.new([])
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 61)
  def _reduce_22(val, _values, result)
     result = Nodes.new([val[1]])
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 62)
  def _reduce_23(val, _values, result)
     result = val[1]
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 65)
  def _reduce_24(val, _values, result)
     result = CallNode.new(val[0], nil)
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 66)
  def _reduce_25(val, _values, result)
     result = CallNode.new(val[0], val[1])
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 67)
  def _reduce_26(val, _values, result)
     result = CallNode.new(val[0], Nodes.new([val[1]]))
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 68)
  def _reduce_27(val, _values, result)
     result = CallNode.new(val[0], val[1])
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 71)
  def _reduce_28(val, _values, result)
     result = DefNode.new(val[0], Nodes.new([val[2]]))
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 72)
  def _reduce_29(val, _values, result)
     result = DefNode.new(val[0], val[2])
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 73)
  def _reduce_30(val, _values, result)
     result = DefNode.new(val[0], val[2])
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 76)
  def _reduce_31(val, _values, result)
     result = val[1]
    result
  end
.,.,

def _reduce_none(val, _values, result)
  val[0]
end

end   # class Parser
