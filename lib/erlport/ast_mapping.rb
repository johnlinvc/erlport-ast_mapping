require "erlport/ast_mapping/version"
require "erlport/erlterms"
require "erlport/erlang"
require "ast"
require "parser/current"

module ErlPort
  module AstMapping

    module_function
    def install_encoder
      ErlPort::Erlang.set_encoder {|v| encode_term v}
      :ok
    end

    module_function
    def parse(src)
      src = src.map(&:chr).join("")
      ast = ::Parser::CurrentRuby.parse(src)
    end

    module_function
    def encode_term term
      if term.respond_to? :to_ast
        encode_ast term.to_ast
      else
        ErlPort::ErlTerm.encode_term term
      end
    end
    Tuple = ErlPort::ErlTerm::Tuple

    module_function
    def encode_ast ast
      if ast.respond_to? :to_ast
        Tuple.new([:ast, :type, ast.type, :children, ast.children.map{|c| encode_ast(c)}])
      else
        ast
      end
    end
  end
end
