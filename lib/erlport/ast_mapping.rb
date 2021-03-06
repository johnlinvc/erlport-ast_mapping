require "erlport/ast_mapping/version"
require "erlport/erlterms"
require "erlport/erlang"
require "ast"
require "parser/current"

module ErlPort
  module AstMapping
    include ErlPort::ErlTerm
    include ErlPort::Erlang

    module_function
    def install_encoder
      ErlPort::Erlang.set_encoder {|v| ast_encoder v}
      :ok
    end

    module_function
    def parse(src)
      src = src.map(&:chr).join("")
      ast = ::Parser::CurrentRuby.parse(src)
    end

    module_function
    def ast_encoder term
      if term.respond_to? :to_ast
        encode_ast term.to_ast
      else
        term
      end
    end
    Tuple = ErlPort::ErlTerm::Tuple

    NotAstError = Class.new

    module_function
    def encode_ast ast
      throw NotAstError unless ast.respond_to? :to_ast
      Tuple.new([:ast, :type, ast.type, :children, ast.children.map{|c| ast_encoder(c)}])
    end
  end
end
