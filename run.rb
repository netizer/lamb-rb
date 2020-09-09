#!/usr/bin/env ruby
$LOAD_PATH << './lib'
require 'lamb/interpreter'

file_name = ARGV[0]
Lamb::Interpreter.new.eval_file_and_write(file_name)
