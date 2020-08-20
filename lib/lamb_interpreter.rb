require "generated/parser"

module LambInterpreter
  def lamb(lines)
    nodes = Parser.new.parse(lines.join)
    nodes.to_forest
  end
end
