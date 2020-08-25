require 'byebug'

class ForestTranslator
  def nodes_node(nodes)
    return(call_node("cgs.context", [])) unless nodes

    translated = nodes.map do |item|
      if item.is_a? SetNode
        item.to_forest
      else
        call_node("cgs.set_value", item.to_forest)
      end
    end
    call_node("cgs.context", node("block", translated))
  end

  def literal_node(value)
    node(value)
  end

  def string_node(value)
    node("data", [ node(value) ])
  end

  def set_node(name, value)
    name_part = node("data", [ node(name) ] )
    call_node("cgs.set", node("block", [name_part, value]))
  end

  def get_node(name)
    call_node("cgs.get", node("data", [ node(name) ]))
  end

  def hash_get_node(name, source)
    call_node("data.hash_get", node("block", [string_node(name), source.to_forest]))
  end

  def fun_call_node(method, arguments)
    name_part = get_node(method)
    if arguments
      call_node("ln.now_with_args", node("block", [arguments.to_forest, name_part]))
    else
      call_node("ln.now", name_part)
    end
  end

  def fun_def_node(arguments, body)
    # WARNING: add arguments as a type_check stage
    if body.is_a? Nodes
      call_node(
        "ln.later",
        call_node(
          "cgs.last",
          body.to_forest
        )
      )
    else
      body.to_forest
    end
  end

  private

  def node(command, children = [])
    { command: command, children: children }
  end

  def call_node(name, body)
    node("call", [
      node("data", [ node(name) ]),
      body
    ])
  end
end
