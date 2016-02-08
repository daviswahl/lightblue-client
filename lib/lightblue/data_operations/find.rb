module Lightblue
  module DataOperations
    class Find
      # @param [Lightblue::Expression, nil] expression
      # @return [self, Lightblue::Expression]
      def query(expression = nil)
        return @query if expression.nil?
        @query = Lightblue::Expressions::Query.new(expression)
        self
      end

      # @param [Lightblue::Expression, nil] expression
      # @return [self, Lightblue::Expression]
      def project(expression = nil)
        return @projection if expression.nil?
        @projection = Lightblue::Expressions::Projection.new(expression)
        self
      end

      # @param [Lightblue::Expression, nil] expression
      # @return [self, Lightblue::Expression]
      def sort(expression = nil, direction = nil)
        return @sort if expression.nil?
        @sort = Lightblue::Expressions::Sort.new(expression, direction)
        self
      end

      # @param [Lightblue::Expression, Range, Array] expression
      # @return [self, Lightblue::Expression]
      def range(expression = nil, type = :to)
        return @range if expression.nil?
        @range = Lightblue::Expressions::Range.new(expression, type)
        self
      end

      # @param [Lightblue::Entity, Symbol] entity
      # @param [String, nil] version
      # @return [self]
      def entity(entity, version = nil)
        case entity
        when Lightblue::Entity
          @entity = entity
        when String, Symbol
          @entity = Entity.new(entity, version)
        end
        self
      end

      def to_query
        {
          entity: @entity.name,
          entityVersion: @entity.version,
          query: @query.to_hash,
          projection: @projection.to_hash,
          range: @range ? @range.to_hash : nil,
          sort: @sort ? @sort.to_hash : nil
        }.delete_if { |k,v| v.nil? }
      end
    end
  end
end
