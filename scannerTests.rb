require 'minitest/autorun'
require_relative 'scanner'

class ScannerTest < MiniTest::Unit::TestCase
    def setup
        @s = Scanner.new
        @expectedTypes = []
        @text = ""
    end

    def teardown
        resultTokens = @s.scan(@text)
        assert_equal(@expectedTypes.length, resultTokens.length)

        @expectedTypes.zip(resultTokens).each do |type, token|
            assert_equal(type, token[:type])
        end
    end

    def test_empty_string
        @text = ""
    end

    def test_whitespace
        @text = " \t\r\n\f\v"
    end

    def test_left_paren
        @text = "("
        @expectedTypes.push :leftParen
    end

    def test_right_paren
        @text = ")"
        @expectedTypes.push :rightParen
    end

    def test_quote
        @text = "'"
        @expectedTypes.push :quote
    end

    def test_symbol_one_char
        @text = "a"
        @expectedTypes.push :symbol
    end

    def test_symbol_many_chars
        @text = "abc"
        @expectedTypes.push :symbol
    end

    def test_unordered
        @text = "a ' ) ("
        @expectedTypes.push(:symbol)
            .push(:quote)
            .push(:rightParen)
            .push(:leftParen)
    end

    def test_multiple_lines
        @text = "a '\n ) ("
        @expectedTypes.push(:symbol)
            .push(:quote)
            .push(:rightParen)
            .push(:leftParen)
    end

    def test_list
        @text = "(a b '(c d) ())"
        @expectedTypes.push(:leftParen)
            .push(:symbol)
            .push(:symbol)
            .push(:quote)
            .push(:leftParen)
            .push(:symbol)
            .push(:symbol)
            .push(:rightParen)
            .push(:leftParen)
            .push(:rightParen)
            .push(:rightParen)
    end

    def test_integer
        @text = "1"
        @expectedTypes.push :lexicalError
    end

    def test_string
        @text = "\"Hello, world!\""
        @expectedTypes.push :lexicalError
    end

    def test_valid_with_gibberish
        @text = "(a b 2 d)"
        @expectedTypes.push(:leftParen)
            .push(:symbol)
            .push(:symbol)
            .push(:lexicalError)
    end
end
