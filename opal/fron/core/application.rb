module Fron
  # Application
  class Application
    class << self
      # Returns the configuration for the application
      #
      # @return [Configuration] The configuration
      def config
        @configuration ||= Configuration.new
      end
    end

    # Initializes the application
    def initialize
      @routeMap = []
      instance_eval(&config.routeBlock) if config.routeBlock
      @router = Router.new @routeMap, config

      DOM::Window.on('load') { loadExternalStylesheets }

      config.logger.info 'Initialized Applicationation!'
      config.logger.info 'Inserting application to DOM!'

      DOM::Document.title = config.title
      DOM::Document.body << config.app
    end

    private

    # Load external stylesheets that are
    # set in the configuration.
    def loadExternalStylesheets
      return unless config.stylesheets
      config.stylesheets.map do |sheet|
        link = DOM::Element.new "link[rel=stylesheet][type=text/css][href=#{sheet}]"
        link.on('load') { config.logger.info "External stylesheet loaded: #{sheet}" }
        DOM::Document.head << link
      end
    end

    # Adds the map to the route map
    #
    # @param args [Array] Array of maps
    def map(*args)
      @routeMap << Router.map(*args)
    end

    # Returns the configuration
    #
    # @return [Configuration] The configuration
    def config
      self.class.config
    end
  end
end
