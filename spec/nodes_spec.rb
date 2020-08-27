require "spec_helper"
require "nodes"

describe Nodes do
  def one_line_data_node(command)
    {
      command: "data",
      children: [
        {
          command: command,
          children: []
        }
      ]
    }
  end

  let(:x_data_node) { one_line_data_node("x") }
  let(:one_data_node) { one_line_data_node("1") }
  let(:testing_log_data_node) { one_line_data_node("testing_log") }
  let(:set_data_node) { one_line_data_node("cgs.set") }
  let(:set_value_data_node) { one_line_data_node("cgs.set_value") }
  let(:get_data_node) { one_line_data_node("cgs.get") }
  let(:context_data_node) { one_line_data_node("cgs.context") }
  let(:now_with_args_data_node) { one_line_data_node("ln.now_with_args") }
  let(:defined_second_data_node) { one_line_data_node("defined second") }
  let(:second_function_data_node) { one_line_data_node("second_function") }
  let(:last_data_node) { one_line_data_node("cgs.last") }
  let(:later_data_node) { one_line_data_node("ln.later") }
  let(:context_with_x_data_node) do
    {
      command: "call",
      children: [
        context_data_node,
        {
          command: "block",
          children: [
            {
              command: "call",
              children: [
                set_value_data_node,
                x_data_node
              ]
            }
          ]
        }
      ]
    }
  end

  it "translates NodesNode" do
    tested =  Nodes.new([StringNode.new({ v: "x", meta: {} })])
    expected = context_with_x_data_node

    expect(tested.to_forest).to eq(expected)
  end

  it "passes meta information" do
    tested =  StringNode.new({ v: "x", meta: { line: 1, pos: 2 } })
    expected = x_data_node.merge(line: 1, pos: 2)
    expected[:children][0].merge!(line: 1, pos: 2)

    expect(tested.to_forest).to eq(expected)
  end

  it "translates SetNode" do
    tested =  Nodes.new([SetNode.new({ v: "x", meta: {} }, StringNode.new({ v: "1", meta: {} }))])
    expected = {
      command: "call",
      children: [
        context_data_node,
        {
          command: "block",
          children: [
            {
              command: "call",
              children: [
                set_data_node,
                {
                  command: "block",
                  children: [
                    x_data_node,
                    one_data_node
                  ]
                }
              ]
            }
          ]
        }
      ]
    }
    expect(tested.to_forest).to eq(expected)
  end

  it "translates CallNode" do
    tested = CallNode.new(
      { v: "testing_log", meta: {} },
      Nodes.new([
        StringNode.new({ v: "defined second", meta: {} })
      ])
    )
    expected = {
      command: "call",
      children: [
        now_with_args_data_node,
        {
          command: "block",
          children: [
            {
              command: "call",
              children: [
                context_data_node,
                {
                  command: "block",
                  children: [
                    {
                      command: "call",
                      children: [
                        set_value_data_node,
                        defined_second_data_node
                      ]
                    }
                  ]
                }
              ]
            },
            {
              command: "call",
              children: [
                get_data_node,
                testing_log_data_node
              ]
            }
          ]
        }
      ]
    }
    expect(tested.to_forest).to eq(expected)
  end

  it "translates DefNode" do
    tested = SetNode.new({ v: "second_function", meta: {} },
      DefNode.new(
        Nodes.new([], {}),
        Nodes.new([
          CallNode.new(
            { v: "testing_log", meta: {} },
            Nodes.new([
              StringNode.new({ v: "defined second", meta: {} })
            ])
          )
        ])
      )
    )
    expected = {
      command: "call",
      children: [
        set_data_node,
        {
          command: "block",
          children: [
            second_function_data_node,
            {
              command: "call",
              children: [
                later_data_node,
                {
                  command: "call",
                  children: [
                    last_data_node,
                    {
                      command: "call",
                      children: [
                        context_data_node,
                        {
                          command: "block",
                          children: [
                            {
                              command: "call",
                              children: [
                                set_value_data_node,
                                {
                                  command: "call",
                                  children: [
                                    now_with_args_data_node,
                                    {
                                      command: "block",
                                      children: [
                                        {
                                          command: "call",
                                          children: [
                                            context_data_node,
                                            {
                                              command: "block",
                                              children: [
                                                {
                                                  command: "call",
                                                  children: [
                                                    set_value_data_node,
                                                    defined_second_data_node
                                                  ]
                                                }
                                              ]
                                            }
                                          ]
                                        },
                                        {
                                          command: "call",
                                          children: [
                                            get_data_node,
                                            testing_log_data_node
                                          ]
                                        }
                                      ]
                                    }
                                  ]
                                }
                              ]
                            }
                          ]
                        }
                      ]
                    }
                  ]
                }
              ]
            }
          ]
        }
      ]
    }
    expect(tested.to_forest).to eq(expected)
  end
end
