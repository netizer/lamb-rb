require 'byebug'

class ForestTranslator
  def nodes_node(nodes, enforced_meta)
    meta = enforced_meta || nodes.first.meta
    return(call_node("cgs.context", [], meta)) unless nodes

    translated = nodes.map do |item|
      if item.is_a? SetNode
        item.to_forest
      else
        call_node("cgs.set_value", item.to_forest, meta)
      end
    end
    call_node("cgs.context", node("block", translated, meta), meta)
  end

  def literal_node(value, meta = {})
    node(value, [], meta)
  end

  def string_node(value)
    node("data", [ node(value[:v], [], value[:meta]) ], value[:meta])
  end

  def set_node(name, value)
    name_part = node("data", [ node(name[:v], [], name[:meta]) ], name[:meta] )
    call_node(
      "cgs.set",
      node("block", [name_part, value], name[:meta]),
      name[:meta]
    )
  end

  def get_node(name)
    call_node(
      "cgs.get",
      node(
        "data",
        [ node(name[:v], [], name[:meta]) ],
        name[:meta]
      ),
      name[:meta]
    )
  end

  def fun_call_node(method, arguments)
    name_part = get_node(method)
    if arguments
      call_node(
        "ln.now_with_args",
        node("block", [arguments.to_forest, name_part], method[:meta]),
        method[:meta]
      )
    else
      call_node("ln.now", name_part, method[:meta])
    end
  end

  def fun_def_node(arguments, body)
    # WARNING: add arguments as a type_check stage
    if body.is_a? Nodes
      call_node(
        "ln.later",
        call_node(
          "cgs.last",
          body.to_forest,
          arguments.meta
        ),
        arguments.meta
      )
    else
      body.to_forest
    end
  end

  private

  def node(command, children, meta = {})
    {
      command: command,
      children: children
    }.merge(meta)
  end

  def call_node(name, body, meta = {})
    node(
      "call",
      [
        node("data", [node(name, [], meta)], meta),
        body
      ],
      meta
    )
  end
end
