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
          name = args[0]
          block = arguments.last.is_a?(Proc) ? arguments.pop : nil
          unless respond_to?(name)
            define_singleton_method name do
              instance_variable_get("@#{name}")
            end
          end
          component(*arguments, &block)
        end
      end

      # Creates a child component
      #
      # @param name [String] The name of the component
      # @param comp [Class] The component
      # @param options [Hash] The options
      # @param block [Proc] The block to eval on the new component
      def component(name, comp, options, &block)
        component = comp.is_a?(Class) ? comp.new(nil, options, @model) : Component.new(comp, options, @model)
        component.instance_eval(&block) if block
        self << component
        instance_variable_set "@#{name}", component
      end
    end
  end
end
