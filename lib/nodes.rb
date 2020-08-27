require "forest_translator"

Translator = ForestTranslator.new

class Nodes < Struct.new(:nodes, :enforced_meta)
  def <<(node) # Useful method for adding a node on the fly.
    nodes << node
    self
  end

  def to_forest
    node = Translator.nodes_node(nodes, enforced_meta)
  end

  def meta
    enforced_meta || nodes.first.meta
  end
end

class LiteralNode < Struct.new(:value)
  def to_forest
    node = Translator.literal_node(value[:v], meta)
  end

  def meta
    value[:meta]
  end
end

class StringNode < LiteralNode
  def to_forest
    node = Translator.string_node(value)
  end

  def meta
    value[:meta]
  end
end

class SetNode < Struct.new(:name, :value)
  def to_forest
    node = Translator.set_node(name, value.to_forest)
  end

  def meta
    name[:meta]
  end
end

class GetNode < Struct.new(:name)
  def to_forest
    node = Translator.get_node(name)
  end

  def meta
    name[:meta]
  end
end

class CallNode < Struct.new(:method, :arguments)
  def to_forest
    node = Translator.fun_call_node(method, arguments)
  end

  def meta
    method[:meta]
  end
end

class DefNode < Struct.new(:arguments, :body)
  def to_forest
    node = Translator.fun_def_node(arguments, body)
  end

  def meta
    arguments.meta
  end
end
