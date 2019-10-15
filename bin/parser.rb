require './lib/token'

class Parser
  RULES = [
    []
  ]
  def self.parse (tokens)
    parse_tree = []
    tokens.each do |token|
      parse_tree += [token]

    end
  end
end

class Node
  attr_reader :type, :children
  
  def initialize(type, children)
    @type = type
    @children = text
  end
end

class Rule
  attr_reader :output, :elements
  def initialize(output, elements)
    @output = output
    @elements = elements
  end
end