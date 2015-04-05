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
      def self.on(args)
        if args.length == 3
          delegate(args[0], args[1]) { |event| send args[2], event }
        else
          on(args[0]) { |event| send args[1], event }
        end
      end
    end
  end
end
