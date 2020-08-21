require 'byebug'
require 'lamb/interpreter'

module Lamb
  def lamb__forest_parse_to_forest(file_name)
    interpreter = Interpreter.new
    interpreter.eval_file(file_name)
  end
end
