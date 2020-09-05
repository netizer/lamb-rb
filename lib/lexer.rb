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
    # Remove extra line breaks
    code.chomp!
    tokens = []

    current_indent = 0
    indent_stack = []

    i = 0
    while i < code.size
      chunk = code[i..-1]
      # name:
      if function_call = chunk[/\A([a-z][\w\.]*:)/, 1]
        tokens << add_token(:FUNCTION_CALL, function_call[0..-2])
        i = increase_i(i, function_call.size)
      # name!
      elsif function_call = chunk[/\A([a-z][\w\.]*!)/, 1]
        tokens << add_token(:FUNCTION_CALL_NO_ARGS, function_call[0..-2])
        i = increase_i(i, function_call.size)
      # =>
      elsif def_call = chunk[/\A(=>)/, 1]
        tokens << add_token(:ARROW, "=>")
        i = increase_i(i, 2)
      # identifier
      elsif identifier = chunk[/\A([a-z][\w\.]*)/, 1]
        tokens << add_token(:IDENTIFIER, identifier)
        i = increase_i(i, identifier.size)
      # "string"
      elsif string = chunk[/\A"([^"]*)"/, 1]
        tokens << add_token(:STRING, string)
        i = increase_i(i, string.size + 2)
      # .. at the end of line - ignore return
      elsif (match = chunk[/\A\n( *)\.\. /]) && (indent = $1) && (indent.size == current_indent)
        i = increase_i(i, match.size, true)
      # return + spaces, when indent exceeds the current one
      elsif (match = chunk[/\A\n( +)/]) && (indent = $1) && (indent.size > current_indent)
        current_indent = indent.size
        indent_stack.push(current_indent)
        i = increase_i(i, indent.size + 1, true)
        tokens << add_token(:NEWLINE, "\n")
        tokens << add_token(:INDENT, indent.size)
      # return + optional spaces, otherwise
      elsif indent = chunk[/\A\n( *)/m, 1]
        if indent.size == current_indent
          tokens << add_token(:NEWLINE, "\n")
        elsif indent.size < current_indent
          while indent.size < current_indent
            indent_stack.pop
            current_indent = indent_stack.last || 0
            tokens << add_token(:NEWLINE, "\n")
            tokens << add_token(:DEDENT, indent.size)
          end
          tokens << add_token(:NEWLINE, "\n")
        end
        i = increase_i(i, indent.size + 1, true)
      # space
      elsif chunk.match(/\A /)
        i = increase_i(i, 1)
      # other single characters
      else
        value = chunk[0,1]
        tokens << add_token(value, value)
        i = increase_i(i, 1)
      end
    end

    while indent = indent_stack.pop
      tokens << add_token(:NEWLINE, "\n")
      tokens << add_token(:DEDENT, indent_stack.first || 0)
    end
    tokens << add_token(:EOF, "")
    tokens
  end
end
