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
      # @param item [Array] Component directive
      def self.component(item)
        arguments = item[:args].dup
        block = item[:block]
        component(*arguments, &block)
      end

      # Creates a child component
      #
      # @param name [String] The name of the component
      # @param comp [Class] The component
      # @param block [Proc] The block to eval on the new component
      def component(name, comp, options = {}, &block)
        component = comp.is_a?(Class) ? comp.new(nil) : Component.new(comp)
        component.instance_eval(&block) if block
        options.each do |key, value|
          if component.respond_to?("#{key}=")
            component.send("#{key}=", value)
          else
            component[key] = value
          end
        end
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
