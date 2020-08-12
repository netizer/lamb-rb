require 'byebug'

module LambInterpreter
  private

  # TODO
  def lamb(tree, direction)
    forward = (@direction == :to_forest)
    {
      command: "call",
      children: [
        {
          command: "data",
          children: [
            {
              command: "cgs.set",
              children: []
            }
          ]
        },
        {
          command: "block",
          children: [
            {
              command: "data",
              children: [
                {
                  command: "x",
                  children: []
                }
              ]
            },
            {
              command: "data",
              children: [
                {
                  command: "1",
                  children: []
                }
              ]
            }
          ]
        }
      ]
    }
  end
end
