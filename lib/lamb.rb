require 'lamb/interpreter'

# This file should be included to Forest Dependencies
# to make Lamb available within Forest.
module Lamb
  def lamb__forest_parse_to_forest(file_name)
    interpreter = Interpreter.new
    interpreter.eval_file(file_name)
  end

  def self.included(klass)
    klass.register_language(
      'lamb' => {
        name: 'Lamb',
        forest_command: 'lamb.parse_text_to_forest',
        method: :lamb__forest_parse_to_forest
      }
    )
  end
end
