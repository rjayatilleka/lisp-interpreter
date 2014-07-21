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

class Scanner
    def initialize()
        @regexes = Array.new(6) { Hash.new }

        @regexes[0][:type] = :leftParen
        @regexes[0][:regex] = /\A\(/
        @regexes[1][:type] = :rightParen
        @regexes[1][:regex] = /\A\)/
        @regexes[2][:type] = :quote
        @regexes[2][:regex] = /\A'/
        @regexes[3][:type] = :integer
        @regexes[3][:regex] = /\A(0|-?[1-9][0-9]*)/
        @regexes[4][:type] = :string
        @regexes[4][:regex] = /\A".*?"/m
        @regexes[5][:type] = :symbol
        @regexes[5][:regex] = /\A[a-zA-Z]\w*/
    end

    def scan(fileName)
        tokens = []

        lispInput = File.new(fileName, "r")
        lispInput.each_line do |line|
            text = line.lstrip
            while !text.empty?
                m = @regexes.find { |v| v[:regex] =~ text }
                tokens.push LispToken.new(m[:type], $&)
                text = $'.lstrip
            end
        end

        lispInput.close
        tokens
    end
end
