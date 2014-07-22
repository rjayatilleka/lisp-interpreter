#!/usr/bin/env ruby

require './scanner'

s = Scanner.new
file = File.new("input.txt", "r")
puts s.scan(file)
file.close
