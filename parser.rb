class RLispExpr
end

class RLispNil < RLispExpr
end

class RLispTrue < RLispExpr
end

class Parser

  attr_accessor :tokens

  def parseNil
    if @tokens.length > 1 and
        @tokens[0][:type] == :leftParen and
        @tokens[1][:type] == :rightParen
      @tokens.shift
      @tokens.shift
      return RLispNil.new
    else
      return nil
    end
  end

  def parseTrue
    if @tokens.length > 0 and
        @tokens[0][:type] == :symbol and
        @tokens[0][:lexeme] == "t"
      @tokens.shift
      return RLispTrue.new
    else
      return nil
    end
  end
end
