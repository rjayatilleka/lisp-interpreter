class Scanner
    def initialize()
        @regexes = Array.new(5) { Hash.new }

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
        
        @regexes[-1][:type] = :lexicalError
        @regexes[-1][:regex] = /\A.*/m
    end

    def scan(lispInput)
        tokens = []

        lispInput.each_line do |line|
            text = line.lstrip

            while !text.empty?
                m = @regexes.find { |v| v[:regex] =~ text }
                tokens.push({:type => m[:type], :lexeme => $&})
                text = $'.lstrip
            end
        end

        tokens
    end
end
