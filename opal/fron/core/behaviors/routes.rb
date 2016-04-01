module Fron
  # Bevahviors
  module Behaviors
    # Components
    module Routes
      # Register a route
      #
      # @param path [String] The path
      # @param action [String] The action to take
      # @param component [Fron::Component] The component
      def self.register(path, action, component)
        @routes << {
          path: Regexp.new(path),
          action: action,
          component: component
        }
      end

      # Handles hash change event
      #
      # @param hash [String] The hash
      def self.handle_hash_change(hash)
        routes = @routes.select { |route_| route_[:path] =~ hash }
        routes.each do |route|
          matches = hash.match route[:path]
          route[:component].send route[:action], *matches[1..-1]
        end
      end

      # Runs for included classes
      #
      # @param base [Class] The class
      def self.included(base)
        base.register self, [:route]

        return if @initialized
        @initialized = true
        @routes = []
        listen
      end

      # Listen on events (maily for tests)
      def self.listen
        DOM::Window.on('popstate') { handle_hash_change DOM::Window.state }
      end

      # Registers routes from the registry
      #
      # @param item [Array] The route
      def self.route(item)
        path, action = item[:args]
        raise "There is no method #{action} on #{self}" unless respond_to? action
        Routes.register path, action, self
      end
    end
  end
end
