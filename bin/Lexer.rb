class Lexer
  KEWORDS = {
    flow: ['if','elif','else','while','for','do','return'],
    type: ['bool','int','void'],
    other: ['class', 'new','private','protected','public','static','super','this']
  }
  
  TOKENS = {
    seperator: ['(', ')', '[', ']', '{', '}', ';', ',', '.', '`'],
    comparason: ['==', '>=', '<=', '!=', '>', '<'],
    assignment: ['=', '+=', '-=', '*=', '/=', '%='],
    operator: [ '++', '--', '+', '-', '*', '/', '%', '&&', '||', '!'], 
    literal: ['true', 'false', /\"(\\\"|[^\"])*\"/, /\d+(\.\d+)?/],
    identifier: [/[A-Za-z_]\w*/],
    comment: ['/*', '*/', '//']
  }

  def self.tokenize (str)
    tokens = []
    str.gsub(/[^\n]+/).each do |line|
      line.gsub(/\S+/).each do |word|
        KEWORDS.each do |name, array|
          array.each do |rule|
            if rule == word
              tokens += [Token.new(name, word)]
              word = ""
            end
          end
        end
        if word != ""
          tokens += scan_word(word)
        end
        tokens += [Token.new(:seperator, " ")]
      end
      tokens += [Token.new(:seperator, "\\n")]
    end

    return tokens[0..-2]
  end

  
  def self.scan_word (word)
    tokens = []
    TOKENS.each do |name, array|
      array.each do |regex|
        match = match_regex(regex, word)
        if match != nil
          tokens += [Token.new(name, match)]
          word = word[match.length..-1]
        end
      end
    end

    if tokens == []
      tokens += [Token.new(:unidentified, word)]
      word = ""
    elsif word != ""
      tokens += scan_word(word)
    end
    
    return tokens
  end


  def self.match_regex (regex, word)
    if regex.is_a?(String) && regex == word[0..regex.length-1]
      return regex
    elsif regex.is_a?(Regexp) && /^#{regex}/.match?(word)
      return /^#{regex}/.match(word)[0]
    else
      return nil
    end
  end
end



class Token
  attr_reader :type, :text

  def initialize(type, text)
    @type = type
    @text = text
  end
end