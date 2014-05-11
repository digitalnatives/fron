module Fron
  class Router
    def initialize(routes,config)
      @config = config
      @routes = routes

      DOM::Window.on 'load' do
        route
      end
      DOM::Window.on 'hashchange' do
        route
      end
    end

    def self.map(*args)
      data = case args.length
      when 1
        action = args[0]
        {path: "*"}
      when 2
        action = args[1]
        {path: Router.pathToRegexp(args[0]) }
      end
      if action.is_a? Class
        data[:controller] = action.new
      else
        data[:action] = action.to_s
      end
      data
    end

    def self.pathToRegexp(path)
      return path if path == "*"
      {regexp: Regexp.new('^'+path.gsub(/:(.+)/, '(.+)')), map: path.match(/:(.+)/).to_a[1..-1] }
    end

    def route(hash = DOM::Window.hash, controller = nil)
      routes = controller ? controller.class.routes : @routes
      routes.each do |r|
        if r[:path] == '*'
          if r[:controller]
            break route(hash,r[:controller])
          else
            break applyRoute(controller,r)
          end
        else
          matches = hash.match(r[:path][:regexp]).to_a[1..-1]
          if matches
            params = {}
            if r[:path][:map]
              r[:path][:map].each_with_index do |key, index|
                params[key.to_sym] = matches[index]
              end
            end
            if r[:action]
              break applyRoute(controller,r,params)
            else
              break route hash.gsub(r[:path][:regexp],''), r[:controller]
            end
          end
        end
      end
    end

    private

    def applyRoute(controller,route, params = {})
      if controller.class.beforeFilters
        controller.class.beforeFilters.each do |filter|
          if filter[:actions].include?(route[:action])
            controller.send(filter[:method], params)
          end
        end
      end
      controller.send(route[:action], params)
      @config.logger.info "Navigate >> #{controller.class}##{route[:action]} with params #{params}"
      @config.main.empty
      @config.main << controller.base
    end
  end
end
