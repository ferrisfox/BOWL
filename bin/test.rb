require_relative 'Lexer'

puts Lexer.tokenize('
  test.abc = 1+  1;
  if test.abc == 2.0
  ').map {|m| m.type.to_s + "\t" + m.text} 