module Lightblue

  module AST
    # This is some DSL stuff. It is a bad idea and is almost removed
    module HasNodes
      def has_nodes(*nodes)
        nodes.each do |n|
          dispatch_hash[n] = Lightblue::AST::Nodes.const_get(n.to_s.capitalize)
          define_method(n) do |*args|
            self.class.dispatch_hash[n].new(self, *args)
          end
        end
      end

      def dispatch_hash
        @@dispatch_hash ||= {}
      end
    end

  end
end
