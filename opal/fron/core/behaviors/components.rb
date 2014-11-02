module Fron
  # Bevahviors
  module Behaviors
    # Components
    module Components
      # Runs for included classes
      #
      # @param base [Class] The class
      def self.included(base)
        base.register self, [:component]
      end

      # Creates components from the registry
      #
      # @param registry [Array] Registry of components
      def self.component(registry)
        registry.each do |args|
          arguments = args.dup
          block = arguments.last.is_a?(Proc) ? arguments.pop : nil
          component(*arguments, &block)
        end
      end

      # Creates a child component
      #
      # @param name [String] The name of the component
      # @param comp [Class] The component
      # @param block [Proc] The block to eval on the new component
      def component(name, comp, &block)
        component = comp.is_a?(Class) ? comp.new(nil) : Component.new(comp)
        component.instance_eval(&block) if block
        self << component
        instance_variable_set "@#{name}", component

        return if respond_to?(name)
        define_singleton_method name do
          instance_variable_get("@#{name}")
        end
      end
    end
  end
end
