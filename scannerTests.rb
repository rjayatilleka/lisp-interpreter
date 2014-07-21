require 'minitest/autorun'
require_relative 'scanner'

class ScannerTest < MiniTest::Unit::TestCase
    def setup
        @s = Scanner.new
    end
end
