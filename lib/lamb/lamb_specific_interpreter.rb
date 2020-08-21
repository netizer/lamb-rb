require "generated/parser"

module LambSpecificInterpreter
  def lamb(lines)
    nodes = Parser.new.parse(lines.join)
    nodes.to_forest
  end
end
