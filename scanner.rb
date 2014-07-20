class LispToken
    attr_accessor :type, :lexeme

    def initialize(type, lexeme)
        @type = type
        @lexeme = lexeme
    end 

    def to_s()
        "<Type: " + type.to_s + ", Lexeme: " + lexeme + ">"
    end
end

class TypeRegex
    attr_accessor :tokenType, :regex

    def initialize(tokenType, regex)
        @tokenType = tokenType
        @regex = regex
    end
end

class Scanner
    def initialize()
        @regexes = Array.new(6)
        @regexes[0] = TypeRegex.new(:leftParen, /\A\(/)
        @regexes[1] = TypeRegex.new(:rightParen, /\A\)/)
        @regexes[2] = TypeRegex.new(:quote, /\A'/)
        @regexes[3] = TypeRegex.new(:integer, /\A-?[1-9][0-9]*/)
        @regexes[4] = TypeRegex.new(:string, /\A".*?"/m)
        @regexes[5] = TypeRegex.new(:symbol, /\A[a-zA-Z]\w*/)
    end

    def scan(fileName)
        tokens = []

        lispInput = File.new(fileName, "r")
        lispInput.each_line do |line|
            text = line.lstrip
            while !text.empty?
                m = @regexes.find { |v| v.regex =~ text }
                tokens.push(LispToken.new(m.tokenType, $&))
                text = $'.lstrip
            end
        end

        lispInput.close
        tokens
    end
end
