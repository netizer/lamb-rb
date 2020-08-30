require 'byebug'

class ForestTranslator
  def nodes_node(nodes, enforced_meta)
    meta = enforced_meta || nodes.first.meta
    return(call_node("context", [], meta)) unless nodes

    translated = nodes.map do |item|
      if item.is_a? SetNode
        item.to_forest
      else
        call_node("cgs.set_value", item.to_forest, meta)
      end
    end
    call_node("context", node("block", translated, meta), meta)
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
      "get",
      node(
        "data",
        [ node(name[:v], [], name[:meta]) ],
        name[:meta]
      ),
      name[:meta]
    )
  end

  def fun_call_node(method, arguments)
    empty_block = node("block", [], method[:meta])
    call_node(
      "format_call",
      node(
        "block",
        [
          node("data", [node(method[:v], [], method[:meta])], method[:meta]),
          arguments ? arguments.to_forest : empty_block
        ],
        method[:meta]
      ),
      method[:meta]
    )
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
