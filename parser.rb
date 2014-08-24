class RLispExpr
end

class RLispNil < RLispExpr
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
end
