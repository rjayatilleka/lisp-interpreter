class RLispError < StandardError
end

class RLispSyntaxError < RLispError
  attr_reader :line, :column, :tokens
  def initialize(line, column, tokens)
    @line = line
    @column = column
    @tokens = tokens
  end

  def message
    "Syntax Error at line #{line}, column #{column}."
  end
end

class Scanner
  def initialize()
    @regexes = Array.new(6) { Hash.new }

    @regexes[0][:type] = :whitespace
    @regexes[0][:regex] = /\A\s+/

    @regexes[1][:type] = :leftParen
    @regexes[1][:regex] = /\A\(/

    @regexes[2][:type] = :rightParen
    @regexes[2][:regex] = /\A\)/

    @regexes[3][:type] = :quote
    @regexes[3][:regex] = /\A'/

    @regexes[4][:type] = :symbol
    @regexes[4][:regex] = /\A[a-zA-Z]\w*/

    @regexes[5][:type] = :lexicalError
    @regexes[5][:regex] = /\A.+/m

    #        @regexes[3][:type] = :integer
    #        @regexes[3][:regex] = /\A(0|-?[1-9][0-9]*)/

    #        @regexes[4][:type] = :string
    #        @regexes[4][:regex] = /\A".*?"/m
  end

  def scan(lispInput)
    tokens = []
    lineNumber = 0

    lispInput.each_line do |line|
      lineNumber += 1
      column = 1

      while !line.empty?
        m = @regexes.find { |v| v[:regex] =~ line }

        if m[:type] == :lexicalError
          raise RLispSyntaxError.new(lineNumber, column, tokens)
        elsif m[:type] != :whitespace
          tokens.push({:type => m[:type], :lexeme => $&})
        end

        line = $'
        column += $&.length
      end
    end

    tokens
  end
end
