require "forest_translator"

Translator = ForestTranslator.new

class Nodes < Struct.new(:nodes)
  def <<(node) # Useful method for adding a node on the fly.
    nodes << node
    self
  end

  def to_forest
    Translator.nodes_node(nodes)
  end
end

class LiteralNode < Struct.new(:value)
  def to_forest
    Translator.literal_node(value)
  end
end

class StringNode < LiteralNode
  def to_forest
    Translator.string_node(value)
  end
end

class SetNode < Struct.new(:name, :value)
  def to_forest
    Translator.set_node(name, value.to_forest)
  end
end

class GetNode < Struct.new(:name)
  def to_forest
    Translator.get_node(name)
  end
end

class HashGetNode < Struct.new(:name, :source)
  def to_forest
    Translator.hash_get_node(name, source)
  end
end

class CallNode < Struct.new(:method, :arguments)
  def to_forest
    Translator.fun_call_node(method, arguments)
  end
end

class DefNode < Struct.new(:arguments, :body)
  def to_forest
    Translator.fun_def_node(arguments, body)
  end
end
