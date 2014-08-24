require 'minitest/autorun'
require_relative 'parser'

class ParserTest < MiniTest::Unit::TestCase

  def setup
    @tokens = []
    @p = Parser.new
  end

  def test_parse_nil_correct
    @tokens.push({:type =>:leftParen, :lexeme => "("})
      .push({:type =>:rightParen, :lexeme => ")"})
    @p.tokens = @tokens
    result = @p.parseNil
    assert_instance_of RLispNil, result
  end

  def test_parse_nil_no_tokens
    @p.tokens = @tokens
    result = @p.parseNil
    assert_nil result
  end

end
