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
      # @param registry [Array] Registry of events
      def self.on(registry)
        registry.each do |args|
          if args.length == 3
            delegate(args[0], args[1]) { |event| send args[2], event }
          else
            on(args[0]) { |event| send args[1], event }
          end
        end
      end
    end
  end
end
