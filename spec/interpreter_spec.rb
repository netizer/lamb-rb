require 'spec_helper'
require 'interpreter'

describe Interpreter do
  describe 'lamb -> forest' do
    it 'transpiles an easy case' do
      interpreter = Interpreter.new
      result = interpreter.eval_file_and_deparse('fixtures/small.lamb')
      expected = File.read('fixtures/small.forest')

      expect(result).to eq(expected)
    end

    it 'transpiles a complex case' do
      interpreter = Interpreter.new
      result = interpreter.eval_file_and_deparse('fixtures/later_now.lamb')
      expected = File.read('fixtures/later_now.forest')

      expect(result).to eq(expected)
    end
  end
end
