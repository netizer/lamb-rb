# Usage: `Lexer.new.tokenize("code")`,
# Each token is a pair: `[TOKEN_TYPE, TOKEN_VALUE]`).
class Lexer
  attr_accessor :meta

  def with_meta(value)
    { value: value, meta: @meta }
  end

  def add_token(token_type, value)
    [
      token_type,
      {
        v: value,
        meta: {
          line: @meta[:line],
          pos: @meta[:pos]
        }
      }
    ]
  end

  def increase_i(i, delta, add_new_line_first = nil)
    if add_new_line_first
      @meta[:line] += 1
      @meta[:pos] = delta
      @meta[:new_lines] += 1
    else
      @meta[:pos] += delta
    end
    @meta[:total_pos] = i + delta
  end

  def tokenize(code)
    @meta = { line: 1, pos: 1, total_pos: 0, new_lines: 0 }
    code.chomp! # Remove extra line breaks
    tokens = []

    current_indent = 0 # number of spaces in the last indent
    indent_stack = []

    i = 0 # Current character position
    while i < code.size
      chunk = code[i..-1]

      if function_call = chunk[/\A([a-z][\w\.]*:)/, 1]
        tokens << add_token(:FUNCTION_CALL, function_call[0..-2])
        i = increase_i(i, function_call.size) # skip what we just parsed

      elsif function_call = chunk[/\A([a-z][\w\.]*!)/, 1]
        tokens << add_token(:FUNCTION_CALL_NO_ARGS, function_call[0..-2])
        i = increase_i(i, function_call.size) # skip what we just parsed

      elsif def_call = chunk[/\A(=>)/, 1]
        tokens << add_token(:ARROW, "=>")
        i = increase_i(i, 2)

      elsif identifier = chunk[/\A([a-z][\w\.]*)/, 1]
        tokens << add_token(:IDENTIFIER, identifier)
        i = increase_i(i, identifier.size) # skip what we just parsed

      elsif string = chunk[/\A"([^"]*)"/, 1]
        tokens << add_token(:STRING, string)
        i = increase_i(i, string.size + 2) # skip two more to exclude the `"`.

      elsif (indent = chunk[/\A\n( +)/m, 1]) && indent && (indent.size > current_indent)
        current_indent = indent.size
        indent_stack.push(current_indent)
        i = increase_i(i, indent.size + 1, true)
        tokens << add_token(:NEWLINE, "\n")
        tokens << add_token(:INDENT, indent.size)

      elsif indent = chunk[/\A\n( *)/m, 1] # Matches "<newline> <spaces>"
        if indent.size == current_indent # Case 2
          tokens << add_token(:NEWLINE, "\n") # Nothing to do, we'r still in the same block
        elsif indent.size < current_indent # Case 3
          while indent.size < current_indent
            indent_stack.pop
            current_indent = indent_stack.last || 0
            tokens << add_token(:NEWLINE, "\n")
            tokens << add_token(:DEDENT, indent.size)
          end
          tokens << add_token(:NEWLINE, "\n")
        end
        i = increase_i(i, indent.size + 1, true)

      elsif chunk.match(/\A /)
        i = increase_i(i, 1)

      # We treat all other single characters as a token. Eg.: `( ) , . ! + - <`.
      else
        value = chunk[0,1]
        tokens << add_token(value, value)
        i = increase_i(i, 1)
      end
    end

    # Close all open blocks.
    # If the code ends without dedenting, this will take care of
    # balancing the `INDENT`...`DEDENT`s.
    while indent = indent_stack.pop
      tokens << add_token(:NEWLINE, "\n")
      tokens << add_token(:DEDENT, indent_stack.first || 0)
    end

    tokens << add_token(:EOF, "")

    tokens
  end
end
