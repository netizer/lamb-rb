class Parser

token NEWLINE
token STRING
token IDENTIFIER
token FUNCTION_CALL
token FUNCTION_CALL_NO_ARGS
token ARROW
token INDENT DEDENT

prechigh
  right '=>'
  right '='
preclow

rule
  Program:
    /* nothing */                      { result = Nodes.new([]) }
  | Expressions                        { result = val[0] }
  ;

  Expressions:
    Expression                         { result = Nodes.new(val) }
  | Expressions Terminator Expression  { result = val[0] << val[2] }
  | Expressions Terminator             { result = val[0] }
  | Terminator                         { result = Nodes.new([]) }
  ;

  Expression:
    Literal
  | Get
  | Set
  | Array
  | Call
  | Def
  | '(' Expression ')'  { result = val[1] }
  ;

  CommaSeparatedItems:
    Expression "," Expression           { result = Nodes.new([val[0], val[2]]) }
  | CommaSeparatedItems "," Expression  { result = val[0] << val[2] }

  Terminator:
    NEWLINE
  | ";"
  ;

  Literal:
    STRING  { result = StringNode.new(val[0]) }
  ;

  Get:
    IDENTIFIER          { result = GetNode.new(val[0]) }
  ;

  Set:
    IDENTIFIER "=" Expression  { result = SetNode.new(val[0], val[2]) }
  | IDENTIFIER "=" Block       { result = SetNode.new(val[0], val[2]) }
  ;

  Array:
    '[' ']'                      { result = Nodes.new([], val[0][:meta]) }
  | '[' Expression ']'           { result = Nodes.new([val[1]]) }
  | '[' CommaSeparatedItems ']'  { result = val[1] }

  Call:
    FUNCTION_CALL_NO_ARGS                  { result = CallNode.new(val[0], nil) }
  | FUNCTION_CALL Block                    { result = CallNode.new(val[0], val[1]) }
  | FUNCTION_CALL Expression ";"           { result = CallNode.new(val[0], Nodes.new([val[1]])) }
  | FUNCTION_CALL CommaSeparatedItems ";"  { result = CallNode.new(val[0], val[1]) }

  Def:
    Array ARROW Expression ";" { result = DefNode.new(val[0], Nodes.new([val[2]])) }
  | Array ARROW CommaSeparatedItems ";" { result = DefNode.new(val[0], val[2]) }
  | Array ARROW Block { result = DefNode.new(val[0], val[2]) }

  Block:
    INDENT Expressions DEDENT  { result = val[1] }
  ;
end

---- header
  require "lexer"
  require "nodes"

---- inner
  def parse(code, show_tokens=false)
    @tokens = Lexer.new.tokenize(code) # Tokenize the code using our lexer
    puts @tokens.inspect if show_tokens
    do_parse # Kickoff the parsing process
  end

  def next_token
    @tokens.shift
  end
