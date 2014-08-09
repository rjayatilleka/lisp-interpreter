class RLispException < StandardError
end

class RLispSyntaxException < RLispException
    attr_reader :msg, :line, :column
    def initialize(msg, line, column)
        @msg = msg
        @line = line
        @column = column
    end

    def message
        "Syntax Error at line #{line}, column #{column}: #{msg}"
    end
end

class Scanner
    def initialize()
        @wsRegex = /\A\s*/

        @regexes = Array.new(4) { Hash.new }

        @regexes[0][:type] = :leftParen
        @regexes[0][:regex] = /\A\(/

        @regexes[1][:type] = :rightParen
        @regexes[1][:regex] = /\A\)/

        @regexes[2][:type] = :quote
        @regexes[2][:regex] = /\A'/

        @regexes[3][:type] = :symbol
        @regexes[3][:regex] = /\A[a-zA-Z]\w*/

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
                @wsRegex =~ line
                line = $'
                column += $&.length

                m = @regexes.find { |v| v[:regex] =~ line }
                if m
                    tokens.push({:type => m[:type], :lexeme => $&})
                    line = $'
                    column += $&.length
                else
                    raise RLispSyntaxException.new("Unknown token.", lineNumber, column)
                end
            end
        end

        tokens
    end
end
