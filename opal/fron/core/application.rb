module Fron
  class Application
    class << self
      def config
        @configuration ||= Configuration.new
      end
    end

    def initialize
      @routeMap = []
      instance_eval &config.routeBlock if config.routeBlock
      @router = Router.new @routeMap, config

      DOM::Window.on('load') { loadExternalStylesheets }

      config.logger.info "Initialized Applicationation!"
      config.logger.info "Inserting application to DOM!"

      DOM::Document.title = config.title
      DOM::Document.body << config.app
    end

    private

    def loadExternalStylesheets
      return unless config.stylesheets
      config.stylesheets.map do |sheet|
        link = DOM::Element.new "link[rel=stylesheet][type=text/css][href=#{sheet}]"
        link.on('load') { config.logger.info "External stylesheet loaded: #{sheet}" }
        DOM::Document.head << link
      end
    end

    def map(*args)
      @routeMap << Router.map(*args)
    end

    def config
      self.class.config
    end
  end
end
