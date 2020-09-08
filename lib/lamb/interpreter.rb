require 'byebug'
require 'lamb/lamb_specific_interpreter'

module Lamb
  class Interpreter
    include LambSpecificInterpreter

    INDENTATION_BASE = 2

    def eval_file_and_write(file)
      output_content = eval_file(file)
      output_file = convert_file_name(file)
      write(output_file, output_content)
    end

    def eval_file_and_deparse_and_write(file)
      output_content = eval_file_and_deparse(file)
      output_file = convert_file_name(file)
      write(output_file, output_content)
    end

    def eval_file_and_deparse(file)
      tree = eval_file(file)
      deparse(tree)
    end

    def eval_file(file)
      @interpreter_file = file
      files_content = read(file)
      tree = eval_text(files_content)
      with_parent(with_additional_meta_data(tree, file))
    end

    def eval_text(files_content)
      lamb(files_content)
    end

    private

    def with_additional_meta_data(tree, file_name)
      tree[:file] = file_name
      tree[:children] = tree[:children].map do |child|
        with_additional_meta_data(child, file_name)
      end
      tree
    end

    def with_parent(tree, parent = nil)
      tree[:parent] = parent
      tree[:children] = tree[:children].map do |child|
        with_parent(child, tree)
      end
      tree
    end

    def deparse(tree, indent = 0)
      head = " " * indent * INDENTATION_BASE + tree[:command]
      has_children = !tree[:children].empty?
      rest = has_children ? tree[:children].map do |ch|
        deparse(ch, indent + 1)
      end.join : ""
      "#{head}\n#{rest}"
    end

    def convert_file_name(file_name)
      new_file = file_name.gsub(/\.lamb\Z/, '.forest')
      if file_name == new_file
        raise "Output file should not be the same as source file."
      end
      new_file
    end

    def read(file)
      File.readlines(file)
    end

    def write(file_name, content)
      File.open(file_name, 'w') do |file|
        file.write(content)
      end
    end
  end
end
