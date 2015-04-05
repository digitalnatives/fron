module Fron
  # Bevahviors
  module Behaviors
    # Events
    module Events
      # Runs for included classes
      #
      # @param base [Class] The class
      def self.included(base)
        base.register self, [:on]
      end

      # Applies events from the registry
      #
      # @param item [Array] Registry of an event
      def self.on(item)
        if item.length == 3
          delegate(item[0], item[1]) { |event| send item[2], event }
        else
          on(item[0]) { |event| send item[1], event }
        end
      end
    end
  end
end
