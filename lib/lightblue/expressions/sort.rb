module Lightblue
  module Expressions
    class Sort < Lightblue::Expression
      # @param [Expression, Array<Expression>] expression
      def initialize(expression = nil, direction = nil)
        ast = case expression
              when Array
                new_node(:sort_expression_array,
                         expression.map { |exp| from_array(exp) })
              when Expressions::Field then from_field(expression, direction)
              when Symbol, String then from_raw(expression, direction)
              when Expression then expression.ast
              end
        super ast
      end

      private

      def from_field(field, direction)
        new_node(:sort_expression, [field.ast,
                                    new_node(:sort_direction,
                                             [direction_token(direction)])])
      end

      def from_raw(field, direction)
        new_node(:sort_expression,
                 [new_node(:field, [field]),
                  new_node(:sort_direction, [direction_token(direction)])])
      end

      def from_array(array)
        field, direction = *array
        case field
        when Symbol, String then from_raw(field, direction)
        when Expressions::Field then from_field(field, direction)
        end
      end

      def direction_token(direction)
        case direction
        when :desc, 'desc' then :$desc
        when :asc, 'asc' then :$asc
        when :$desc, :$asc, '$asc', '$desc' then direction
        end
      end
    end
  end
end
