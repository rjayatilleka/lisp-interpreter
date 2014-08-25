require 'minitest/autorun'
require_relative 'parser'

class ParserTest < MiniTest::Unit::TestCase

  def setup
    @tokens = []
    @p = Parser.new
  end

  def test_parse_nil_no_tokens
    @p.tokens = @tokens
    result = @p.parseNil
    assert_nil result
    assert_equal 0, @tokens.length
  end

  def test_parse_nil_one_token
    @tokens.push({:type => :leftParen, :lexeme => "("})
    @p.tokens = @tokens
    result = @p.parseNil
    assert_nil result
    assert_equal 1, @tokens.length
  end

  def test_parse_nil_bad_first_type
    @tokens.push({:type => :symbol, :lexeme => "a"})
      .push({:type => :rightParen, :lexeme => ")"})
    @p.tokens = @tokens
    result = @p.parseNil
    assert_nil result
    assert_equal 2, @tokens.length
  end

  def test_parse_nil_bad_second_type
    @tokens.push({:type => :leftParen, :lexeme => "("})
      .push({:type => :symbol, :lexeme => "a"})
    @p.tokens = @tokens
    result = @p.parseNil
    assert_nil result
    assert_equal 2, @tokens.length
  end

  def test_parse_nil_correct
    @tokens.push({:type => :leftParen, :lexeme => "("})
      .push({:type => :rightParen, :lexeme => ")"})
    @p.tokens = @tokens
    result = @p.parseNil
    assert_instance_of RLispNil, result
    assert_equal 0, @tokens.length
  end

  def test_parse_true_no_tokens
    @p.tokens = @tokens
    result = @p.parseTrue
    assert_nil result
    assert_equal 0, @tokens.length
  end

  def test_parse_true_bad_type
    @tokens.push({:type => :leftParen, :lexeme => "t"})
    @p.tokens = @tokens
    result = @p.parseTrue
    assert_nil result
    assert_equal 1, @tokens.length
  end

  def test_parse_true_bad_lexeme
    @tokens.push({:type => :symbol, :lexeme => "a"})
    @p.tokens = @tokens
    result = @p.parseTrue
    assert_nil result
    assert_equal 1, @tokens.length
  end

  def test_parse_true_correct
    @tokens.push({:type => :symbol, :lexeme => "t"})
    @p.tokens = @tokens
    result = @p.parseTrue
    assert_instance_of RLispTrue, result
    assert_equal 0, @tokens.length
  end

  def test_parse_symbol_no_tokens
    @p.tokens = @tokens
    result = @p.parseSymbol
    assert_nil result
    assert_equal 0, @tokens.length
  end

  def test_parse_symbol_bad_type
    @tokens.push({:type => :quote, :lexeme => "'"})
    @p.tokens = @tokens
    result = @p.parseSymbol
    assert_nil result
    assert_equal 1, @tokens.length
  end

  def test_parse_symbol_correct
    @tokens.push({:type => :symbol, :lexeme => "a"})
    @p.tokens = @tokens
    result = @p.parseSymbol
    assert_instance_of RLispSymbol, result
    assert_equal result.name, "a"
    assert_equal 0, @tokens.length
  end

end
