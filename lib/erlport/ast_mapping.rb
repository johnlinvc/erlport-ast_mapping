require "erlport/ast_mapping/version"
require "erlport/erlang"
require "erlport/erlterm"
require "ast"

module ErlPort
  module AstMapping
    module_function
    def encode_term term
      if term.is_a? AST::Node
        encode_ast ast
      else
        ErlPost::ErlTerm.encode_term term
      end
    end

    module_function
    def encode_ast ast

    end
  end
end
