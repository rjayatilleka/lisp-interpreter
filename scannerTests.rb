require 'minitest/autorun'
require_relative 'scanner'

class ScannerTest < MiniTest::Unit::TestCase
  def setup
    @s = Scanner.new
    @expectedTokens = []
    @text = ""
  end

  def matchTokens(expectedTokens, resultTokens)
    assert_equal expectedTokens.length, resultTokens.length

    expectedTokens.zip(resultTokens).each do |expected, result|
      assert_equal expected[:type], result[:type]
      assert_equal expected[:lexeme], result[:lexeme]
    end
  end

  def run_tests_no_errors
    resultTokens = @s.scan(@text)
    matchTokens @expectedTokens, resultTokens
  end

  def test_empty_string
    @text = ""
    run_tests_no_errors()
  end

  def test_whitespace
    @text = " \t\r\n\f\v"
    run_tests_no_errors()
  end

  def test_left_paren
    @text = "("
    @expectedTokens.push({:type =>:leftParen, :lexeme => "("})
    run_tests_no_errors()
  end

  def test_right_paren
    @text = ")"
    @expectedTokens.push({:type =>:rightParen, :lexeme => ")"})
    run_tests_no_errors()
  end

  def test_quote
    @text = "'"
    @expectedTokens.push({:type =>:quote, :lexeme => "'"})
    run_tests_no_errors()
  end

  def test_symbol_one_char
    @text = "a"
    @expectedTokens.push({:type =>:symbol, :lexeme => "a"})
    run_tests_no_errors()
  end

  def test_symbol_many_chars
    @text = "abc"
    @expectedTokens.push({:type =>:symbol, :lexeme => "abc"})
    run_tests_no_errors()
  end

  def test_unordered
    @text = "a ' ) ("
    @expectedTokens.push({:type => :symbol, :lexeme => "a"})
      .push({:type => :quote, :lexeme => "'"})
      .push({:type => :rightParen, :lexeme => ")"})
      .push({:type => :leftParen, :lexeme => "("})
    run_tests_no_errors()
  end

  def test_multiple_lines
    @text = "a '\n ) ("
    @expectedTokens.push({:type => :symbol, :lexeme => "a"})
      .push({:type => :quote, :lexeme => "'"})
      .push({:type => :rightParen, :lexeme => ")"})
      .push({:type => :leftParen, :lexeme => "("})
    run_tests_no_errors()
  end

  def test_list
    @text = "(a b '(c d) ())"
    @expectedTokens.push({:type => :leftParen, :lexeme => "("})
      .push({:type => :symbol, :lexeme => "a"})
      .push({:type => :symbol, :lexeme => "b"})
      .push({:type => :quote, :lexeme => "'"})
      .push({:type => :leftParen, :lexeme => "("})
      .push({:type => :symbol, :lexeme => "c"})
      .push({:type => :symbol, :lexeme => "d"})
      .push({:type => :rightParen, :lexeme => ")"})
      .push({:type => :leftParen, :lexeme => "("})
      .push({:type => :rightParen, :lexeme => ")"})
      .push({:type => :rightParen, :lexeme => ")"})
    run_tests_no_errors()
  end

  def test_integer
    @text = "1"
    @expectedTokens.push({:type => :lexicalError, :lexeme => "1"})
  end

  def test_string
    @text = "\"Hello, world!\""
    @expectedTokens.push({:type => :lexicalError, :lexeme => "\"Hello, world!\""})
  end

  def test_valid_with_gibberish
    @text = "(a b 2 d)"
    @expectedTokens.push({:type => :leftParen, :lexeme => "("})
      .push({:type => :symbol, :lexeme => "a"})
      .push({:type => :symbol, :lexeme => "b"})
      .push({:type => :lexicalError, :lexeme => "2 d)"})
  end

  def test_erronous_multiple_lines
    @text = "(a b 2 \nd)"
    @expectedTokens.push({:type => :leftParen, :lexeme => "("})
      .push({:type => :symbol, :lexeme => "a"})
      .push({:type => :symbol, :lexeme => "b"})
      .push({:type => :lexicalError, :lexeme => "2 \n"})
  end
end
