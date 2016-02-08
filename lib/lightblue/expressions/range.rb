module Lightblue
  module Expressions
    class Range < Lightblue::Expression
      # @param [::Range, Array, Fixnum, Expression] expression
      # @param [Symbol] type :to | :max | :maxResults
      def initialize(expression, type = :to)
        ast = case expression
              when Expression then expression.ast
              when Array, ::Range then build_ast(expression, type)
              end
        super ast
      end

      def build_ast(range, type)
        type = :maxResults if type == :max
        new_node(:range_expression,
                 [new_node(:value, [range.first]),
                  new_node(:option, [new_node(:value, [type]),
                                     new_node(:value, [range.last])])])
      end
    end
  end
end
