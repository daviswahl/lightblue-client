module Lightblue
  # rubocop:disable Metrics/ModuleLength
  module AST
    module Tokens
      OPERATORS = {
        unary_logical_operator: [:$not],
        nary_logical_operator: [:$and, :$or, :$all, :$any],
        nary_comparison_operator: [:$in, :$not_in, :$nin],
        binary_comparison_operator: [:"=", :!=, :<, :>, :<=, :>=, :$eq, :$neq, :$lt, :$gt, :$lte, :$gte],
        array_contains_operator: [:$any, :$all, :$none]
      }.freeze

      UNIONS = {
        # Queries

        query_expression: [:logical_expression, :comparison_expression],
        logical_expression: [:unary_logical_expression, :nary_logical_expression],
        comparison_expression: [:relational_expression, :array_comparison_expression],
        relational_expression: [:binary_relational_expression, :nary_relational_expression, :regex_match_expression],
        binary_relational_expression: [:field_comparison_expression, :value_comparison_expression],
        nary_relational_expression: [:nary_field_relational_expression, :nary_value_relational_expression],
        array_comparison_expression: [:array_contains_expression, :array_match_expression],

        # Projections

        projection: [:basic_projection, :basic_projection_array],
        basic_projection: [:field_projection, :array_projection],
        array_projection: [:array_match_projection, :array_range_projection],

        # Sort

        sort: [:sort_key, :sort_key_array],

        # Not part of the spec
        maybe_boolean: [:boolean, :empty],
        maybe_projection: [:project, :empty],
        maybe_sort: [:sort, :empty]
      }.freeze

      REVERSE_UNIONS = UNIONS.inject({}) do |acc, (k, v)|
        v.each { |i| acc[i] = k }
        acc
      end

      EXPRESSIONS =
        {

          # Queries

          unary_logical_expression:  [
            { op: :unary_logical_operator },
            { expression: :query_expression }
          ],

          nary_logical_expression:   [
            { op: :nary_logical_operator },
            { expressions: :query_array }
          ],

          array_match_expression:    [
            { array: :array_field },
            { elemMatch: :query_expression }
          ],

          nary_field_relational_expression:  [
            { field: :field },
            { op: :nary_comparison_operator },
            { rfield: :array_field }
          ],

          nary_value_relational_expression:  [
            { field: :field },
            { op: :nary_comparison_operator },
            { values: :value_list_array }
          ],

          field_comparison_expression:  [
            { field: :field },
            { op: :binary_comparison_operator },
            { rfield: :field }
          ],

          value_comparison_expression:  [
            { field: :field },
            { op: :binary_comparison_operator },
            { rvalue: :value }
          ],

          regex_match_expression:  [
            { field:     :field },
            { regex:     :pattern },
            { extended:  :maybe_boolean },
            { multiline: :maybe_boolean },
            { dotall:    :maybe_boolean },
            { caseInsensitive:  :maybe_boolean }
          ],

          array_contains_expression: [
            { array: :array_field },
            { contains: :array_contains_operator },
            { values: :value_list_array }
          ],

          # Projections

          field_projection: [
            { field: :pattern },
            { include: :maybe_boolean },
            { recursive: :maybe_boolean }
          ],

          array_match_projection: [
            { field: :pattern },
            { include: :boolean },
            { match: :query_expression },
            { project: :maybe_projection },
            { sort: :maybe_sort }
          ],

          array_range_projection: [
            { field: :pattern },
            { include: :maybe_boolean },
            { range: :range },
            { project: :maybe_projection },
            { sort: :maybe_sort }
          ]

        }.freeze

      ATOMS = [
        :value_list_array,
        :array,
        :field,
        :value,
        :boolean,
        :pattern,
        :array_field,
        :value,
        :empty
      ].freeze

      TERMINALS = ATOMS.dup.concat(OPERATORS.keys)
    end
  end
end
