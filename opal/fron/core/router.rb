module Fron
  # Router
  class Router
    # Initializes the router
    #
    # @param routes [Array] The routes
    # @param config [Configuration] The configuration
    #
    # @return [type] [description]
    def initialize(routes, config)
      @config = config
      @routes = routes

      DOM::Window.on 'load' do
        route
      end
      DOM::Window.on 'hashchange' do
        route
      end
    end

    # Maps the arguments into a route
    #
    # @param args [Array] The arguments
    #
    # @return [Hash] The route
    def self.map(*args)
      data = case args.length
             when 1
               action = args[0]
               { path: '*' }
             when 2
               action = args[1]
               { path: Router.pathToRegexp(args[0]) }
             end
      if action.is_a? Class
        data[:controller] = action.new
      else
        data[:action] = action.to_s
      end
      data
    end

    # Converts a string representation of the route into a route
    #
    # @param path [String] The path
    #
    # @return [Hash] The route
    def self.pathToRegexp(path)
      return path if path == '*'
      { regexp: Regexp.new('^' + path.gsub(/:([^\/]+)/, '([^\/]+)')), map: path.scan(/:([^\/]+)/).flatten }
    end

    # Finds an action to take from the given arguments
    #
    # @param hash [String] The route string to route to
    # @param controller [Fron::Controller] The controller that has the action
    # @param startParams [Hash] The parameters to pass along
    def route(hash = DOM::Window.hash, controller = nil, startParams = {})
      routes = controller ? (controller.class.routes || []) : @routes
      routes.each do |route|
        path = route[:path]
        routeController = route[:controller]

        if path == '*'
          if routeController
            break self.route(hash, routeController, startParams)
          else
            break applyRoute(controller, route, startParams)
          end
        else
          matches = hash.match(path[:regexp]).to_a[1..-1]
          if matches
            params = {}
            if path[:map]
              path[:map].each_with_index do |key, index|
                params[key.to_sym] = matches[index]
              end
            end
            if route[:action]
              break applyRoute(controller, route, startParams.merge(params))
            else
              break self.route hash.gsub(path[:regexp], ''), routeController, startParams.merge(params)
            end
          end
        end
      end
    end

    private

    # Applies a route to a controller
    #
    # @param controller [Fron::Controller] The controller
    # @param route [Hash] The route
    # @param params [Hash] The parameters to pass along
    def applyRoute(controller, route, params = {})
      klass = controller.class
      action = route[:action]

      if klass.beforeFilters
        klass.beforeFilters.each do |filter|
          next unless filter[:actions].include?(action)
          controller.send(filter[:method], params)
        end
      end
      controller.send(:empty) if controller.respond_to?(:empty)
      controller.send(action, params)
      @config.logger.info "Navigate >> #{klass}##{action} with params #{params}"
      @config.main.empty
      if @config.injectBlock
        @config.injectBlock.call controller.base
      else
        @config.main << controller.base
      end
    end
  end
end
