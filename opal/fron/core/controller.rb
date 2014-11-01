module Fron
  # Controller
  class Controller
    class << self
      attr_reader :baseComponent, :routes, :beforeFilters, :events

      # Sets the base component
      #
      # @param component [Component] The base component
      def base(component)
        @baseComponent = component
      end

      # Sets up routes
      #
      # @param args [Array] The arguments
      def route(*args)
        @routes ||= []
        @routes << Router.map(*args)
      end

      # Adds events
      #
      # @param name [String] The name
      # @param action [String] The action
      def on(name, action)
        @events ||= []
        @events << { name: name, action: action }
      end

      # Adds before filters
      #
      # @param method [String] The method
      # @param actions [Array] The actions
      def before(method, actions)
        @beforeFilters ||= []
        @beforeFilters << { method: method, actions: actions }
      end
    end

    attr_reader :base

    # Initializes the controller
    def initialize
      klass = self.class

      @base = if klass.baseComponent
                klass.baseComponent.new
              else
                DOM::Element.new 'div'
              end

      return unless klass.events
      klass.events.each do |event|
        Eventable.on event[:name] do send(event[:action]) end
      end
    end
  end
end
