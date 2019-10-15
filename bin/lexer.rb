require './lib/token'

class Lexer
  TOKENS = {
    # keywords, current list was taken from java 
    # and does not match the final keyword list 
    if: 'if', elif: 'elif', else: 'else', while: 'while', for: 'for', do: 'do',
    return: 'return', boolean: 'bool', int: 'int', void: 'void', class: 'class',
    new: 'new', private: 'private', protected: 'protected', public: 'public',
    static: 'static', super: 'super', this: 'this',

    
    # punctuation. i.e. symbols that seperate stuff
    instruction_seperator: ';',
    list_seperator: ',',
    identifier_seperator: '.',

    # brackets. i.e. symbols that group stuff together
    open_paren: '(', close_paren: ')',
    open_bracket: '[', close_bracket: ']',
    open_brace: '{', close_brace: '}',
    

    # comparison operators
    eqeq: '==', gteq: '>=', lteq: '<=', nteq: '!=', gt: '>', lt: '<',

    # assignment operators
    eq: '=', plus_eq: '+=', minus_eq: '-=',
    mult_eq: '*=', div_eq: '/=', mod_eq: '%=',


    # mathamatical operators
    incrament: '++', decrament: '--',
    plus: '+', minus: '-', mult: '*', div: '/', mod: '%',

    # boolean operators
    bool_and: '&&', bool_or: '||', bool_not: '!',


    # literal statements
    bool_true: 'true', bool_false: 'false',
    string: /\"(\\\"|[^\"])*\"/,
    decimal: /\d+\.\d+/,
    integer: /\d+/,

    # variables, methods, constants, classes, etc.
    identifier: /[A-Za-z_]\w*/,

    # comments
    comment_line: /\/\/[^\n]*(?=\n)/, # "// comment here"
    comment_block: /\/\*(\\.|[^\*]|\*(?!\/))*\*\//, # "/* comment here */"

    # white space
    white_space: /[ \t]/, new_line: '\n',

    # when something breaks
    unknown: /./
    }.freeze

  def self.tokenize(str)
    matches = TOKENS.map { |symbol, pattern| 
      match = match_regex(pattern, str);
      match ? [symbol, match] : nil
    }.compact.to_h

    len = matches.values.map(&:length).max

    matches = matches.map { |symbol, match| 
      match.length == len ? [symbol, match] : nil
    }.compact.to_h

    token = nil
    if matches.length == 1
      token = Token.new(matches.keys[0], matches[matches.keys[0]])
    else
      matches.each do |symbol, match|
        token = Token.new(symbol, match) if TOKENS[symbol].is_a?(String)
      end
      if token.nil?
        token = Token.new(matches.keys[0], matches[matches.keys[0]])
      end
    end

    if ( str.length == len )
      return token
    else
      return [token, tokenize(str[len..-1])].flatten
    end
  end


  def self.match_regex(regex, str)
    if regex.is_a?(String) && regex == str[0..regex.length-1]
      return regex
    elsif regex.is_a?(Regexp) && /^#{regex}/.match?(str)
      return /^#{regex}/.match(str)[0]
    else
      return nil
    end
  end
end
