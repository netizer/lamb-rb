class Parser

token NEWLINE
token STRING
token IDENTIFIER
token FUNCTION_CALL
token FUNCTION_CALL_NO_ARGS
token ARROW
token INDENT DEDENT
token EOF

prechigh
  right '=>'
  right '='
preclow

rule
  Program:
    /* nothing */ { result = Nodes.new([]) }
  | Chunks   { result = val[0] }
  ;

  /* Chunk is an expression taking at least one whole line */
  Chunks:
    Chunk { result = Nodes.new([val[0]]) }
  | Chunks Chunk { result = val[0] << val[1] }
  ;

  Chunk:
    LiteralChunk
  | CallNoArgsChunk
  | GetChunk
  | SetChunk
  | ArrayChunk
  | CallChunk
  | DefChunk
  ;

  LiteralChunk:
    Literal Terminator { result = val[0] }
  ;

  GetChunk:
    Get Terminator { result = val[0] }
  ;

  CallNoArgsChunk:
    CallNoArgs Terminator { result = val[0] }

  SetChunk:
    Set Terminator { result = val[0] }
  ;

  ArrayChunk:
    Array Terminator { result = val[0] }
  ;

  Item:
    Literal
  | Get
  | Set
  | Array
  | Call
  | CallNoArgs
  | Def
  ;

  Items:
    Item           { result = Nodes.new([val[0]]) }
  | Items "," Item { result = val[0] << val[2] }

  Block:
    NEWLINE INDENT Chunks DEDENT { result = val[2] }
  ;

  NewLines:
    NEWLINE
  | NewLines NEWLINE
  ;

  Terminator:
    NewLines
  | EOF
  ;

  Literal:
    STRING  { result = StringNode.new(val[0]) }
  ;

  Get:
    IDENTIFIER { result = GetNode.new(val[0]) }
  ;

  CallNoArgs:
    FUNCTION_CALL_NO_ARGS { result = CallNode.new(val[0], nil) }

  SetChunk:
    IDENTIFIER "=" Item Terminator { result = SetNode.new(val[0], val[2]) }
  | IDENTIFIER "=" Block Terminator { result = SetNode.new(val[0], val[2]) }
  | IDENTIFIER "=" CallChunk { result = SetNode.new(val[0], val[2]) }
  | IDENTIFIER "=" DefChunk { result = SetNode.new(val[0], val[2]) }
  ;

  Set:
    "(" IDENTIFIER "=" Item ")" { result = SetNode.new(val[1], val[3]) }
  ;

  Array:
    '[' ']'        { result = Nodes.new([], val[0][:meta]) }
  | '[' Items ']'  { result = val[1] }
  ;

  CallChunk:
    FUNCTION_CALL Block Terminator   { result = CallNode.new(val[0], val[1]) }
  | FUNCTION_CALL Items Terminator   { result = CallNode.new(val[0], val[1]) }
  | FUNCTION_CALL Items FUNCTION_CALL Block Terminator
  ;

  Call:
    "(" FUNCTION_CALL Items ")"    { result = CallNode.new(val[1], val[2]) }
  ;

  DefChunk:
    Array ARROW Block Terminator { result = DefNode.new(val[0], val[2]) }
  | Array ARROW Items Terminator { result = DefNode.new(val[0], val[2]) }
  | Array ARROW Block { result = DefNode.new(val[0], val[2]) }
  ;

  Def:
    "(" Array ARROW Items ")"
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
