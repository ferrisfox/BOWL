require 'rspec'
require './bin/parser'

describe "Parser" do
  it "Should raise exception to syntatic errors" do
    expect {
      Parser.parse(
        Lexer.tokenize("
          152 = [python /
          print(\"text / 65);"
        )
      )
    }.to raise_error
  end
end