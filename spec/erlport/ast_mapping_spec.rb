require 'spec_helper'

describe ErlPort::AstMapping do
  it 'has a version number' do
    expect(ErlPort::AstMapping::VERSION).not_to be nil
  end

  it "create a tuple with :ast " do
    term = ErlPort::AstMapping.parse_string("1+1")
    tuple = ErlPort::AstMapping.ast_encoder(term)
    expect(tuple[0]).to eq :ast
  end

  it "create a tuple with :type" do
    term = ErlPort::AstMapping.parse_string("1+1")
    tuple = ErlPort::AstMapping.ast_encoder(term)
    expect(tuple[1]).to eq :type
  end

  it "create a tuple with its type" do
    term = ErlPort::AstMapping.parse_string("1+1")
    tuple = ErlPort::AstMapping.ast_encoder(term)
    expect(tuple[2]).to eq :send
  end

  it "create a tuple with :children" do
    term = ErlPort::AstMapping.parse_string("1+1")
    tuple = ErlPort::AstMapping.ast_encoder(term)
    expect(tuple[3]).to eq :children
  end

  it "can parse a class definition" do
    class_str = <<-CLASS_STR
    class Foo < String
      def initialize(param1, *args, &block)
      end
    end
    CLASS_STR

    term = ErlPort::AstMapping.parse_string(class_str)
    expect( ErlPort::AstMapping.ast_encoder(term)[2] ).to eq :class
  end

  it "can parse a string" do
    string_str = <<-STR_STR
    "the quick brown fox jumps over the lazy dog"
    STR_STR
    term = ErlPort::AstMapping.parse_string(string_str)
    expect( ErlPort::AstMapping.ast_encoder(term)[2] ).to eq :str
  end

  it "can parse a neg int" do
    neg_int_str = <<-NEG_INT
    -1
    NEG_INT
    term = ErlPort::AstMapping.parse_string(neg_int_str)
    expect(ErlPort::AstMapping.ast_encoder(term)[4]).to eq([-1])
  end

  it "can parse with ord array" do
    ord_array = "1+1".each_char.map(&:ord)
    term = ErlPort::AstMapping.parse(ord_array)
    tuple = ErlPort::AstMapping.ast_encoder(term)
    expect(tuple[0]).to eq :ast
  end

end
