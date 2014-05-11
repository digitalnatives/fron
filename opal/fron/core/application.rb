module Fron
  class Application
    class << self
      def config
        @configuration ||= Configuration.new
      end
    end

    def initialize
      @routeMap = []
      DOM::Document.title = config.title
      instance_eval &config.routeBlock
      @router = Router.new @routeMap, config

      DOM::Window.on 'load' do
        config.stylesheets.map do |sheet|
          link = DOM::Element.new("link[rel=stylesheet][type=text/css][href=#{sheet}]")
          link.on 'load' do
            config.logger.info "External stylesheet loaded: #{sheet}"
          end
          DOM::Document.head << link
        end
      end
      config.logger.info "Initialized Applicationation!"
      config.logger.info "Inserting application to DOM!"
      DOM::Document.body << config.app
    end

    private

    def map(*args)
      @routeMap << Router.map(*args)
    end

    def config
      self.class.config
    end
  end
end
