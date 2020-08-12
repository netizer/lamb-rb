require 'byebug'
require 'interpreter'

module Lamb
  # TODO: not used at the moment
  def lamb__forest_parse_text_to_forest(node)
    files_content = node.join("\n")
    eval_text(files_content)
  end

  def lamb__forest_parse_to_forest(file_name)
    interpreter = Interpreter.new(direction = :to_forest)
    interpreter.eval_file(file_name)
  end
end
