require 'byebug'

module LambInterpreter

  class Parser
    INDENTATION = 2

    def initialize(parser)
      @buffer = []
      @parser = parser
    end

    def process
      @tree = process_tree(tree)
    end

    def process_tree(node)
      if node[:token_type] == "programme"
        children = node[:token].map { |t| process_tree(t) }
        {
          command: "call",
          children: children
        }
    end

    def tree
      @tree
    end

    def next(token_type, token)
      @buffer << { token: token, token_type: token_type }

      reorganize_buffer
    end

    def reorganize_buffer
      token_types = @buffer.map { |t| t[:token_type] }

      if token_types[-2..] == ["name", ":"]
        @buffer = @buffer[-3] + [{ token: @buffer[-2], token_type: "call" }]
      elsif token_types[-3..] == ["(", "expressions", ")"]
        @buffer = @buffer[-4] + [{ token: @buffer[-2], token_type: "group" }]
      elsif token_types[-3..] == ["expressions", "=", "expressions"]
        @buffer = @buffer[-4] + [{ token: [@buffer[-3], @buffer[-1]], token_type: "assignment" }]
      elsif
        raise "Unknown token sequence: #{@buffer}"
      end
    end
  end

  class IndentationMiddleware
    def initialize(parser)
      @parser = parser
      @previous_indentation_level = 0
    end

    def next(token_type, token)
      if (token_type == "spaces") && (@buffer[-1][:token_type] == "\n")
        indentation_size = token.length
        if indentation_size > @previous_indentation_level
          token_type = "indent"
          @parser.next(token_type, token)
        elsif indentation_size < @previous_indentation_level
          chunks = (@previous_indentation_level - indentation_size) / INDENTATION
          token_type = "dedent"
          token = "  "
          chunks.times do
            @parser.next(token_type, token)
          end
        end
        @previous_indentation_level = indentation_size
      else
        @parser.next(token_type, token)
      end
      return if skip_token
    end
  end

  class Lexer
    def initialize(parser)
      @buffer_type = nil
      @buffer = ""
      @parser = parser
    end

    def next(character)
      character_type =
        if character[/a-z/]
          :alpha
        elsif [/0-9/]
          :num
        else
          :special
        end

      if (@buffer_type == "name") && [:alpha, :num].include?(character_type)
        @buffer << character
      elsif !@buffer_type && character_type == :alpha
        @buffer << character
        @buffer_type = "name"
      elsif (@buffer_type == "data") && data_end?(character, @buffer)
        @parser.next(@buffer_type, @buffer)
        @buffer = nil
        @buffer_type = nil
      elsif (@buffer_type != "data") && (character == '"')
        @parser.next(@buffer_type, @buffer)
        @buffer_type = "data"
        @buffer = nil
      elsif (@buffer_type == "spaces") && (character == " ")
        @buffer << character
      elsif (@buffer_type != "spaces") && (character == " ")
        @parser.next(@buffer_type, @buffer)
        @buffer_type = "spaces"
        @buffer = character
      elsif character_type == :special
        @parser.next(character, character)
      else
        state = {
          character: character,
          buffer: @buffer,
          buffer_type: @buffer_type
        }
        raise "Unsupported condition: #{state.inspect}"
      end

      private

      def data_end?(character, buffer)
        return false unless character == '"'
        return true unless buffer[-1] == "\\"

        escape_characters = buffer[/[\\]+\Z/]
        return true if escape_characters.length.odd?

        false
      end
    end

    def start
      @parser.next("bof", "")
    end

    def finish
      @parser.next("eof", "")
    end
  end

  def lamb(contents)
    parser = Parser.new
    indentation_middleware = IndentationMiddleware.new(parser)
    lexer = Lexer.new(indentation_middleware)
    lexer.start
    contents.each do |char|
      lexer.next(char)
    end
    lexer.finish
    lexer.process
    lexer.tree
  end
end
