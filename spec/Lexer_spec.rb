require 'rspec'
require './bin/lexer'

describe "Lexer" do
  it "should tokenize multiple literal assignments" do
    expect(Lexer.tokenize("
      abc = 123;
      first_prime = 2;
      hello = \"world\";
    ").find { |token| token.type == :unknown } 
    ).to be_nil
  end

  it "should tokenize method calls" do
    expect(Lexer.tokenize("
      object.function(variable);
    ").find { |token| token.type == :unknown } 
    ).to be_nil
  end

  it "should tokenize syntatic and symantic errors" do
    expect(Lexer.tokenize("

      152 = [python /
      print \"text\" / 65;
      
    ").find { |token| token.type == :unknown } 
    ).to be_nil
  end

  it "should continue scanning on lexical errors" do
    expect(Lexer.tokenize("
      \"tokenizeMe
    ").find { |token| token.type == :identifier && token.text = "tokenizeMe" } 
    ).to_not be_nil
  end
end