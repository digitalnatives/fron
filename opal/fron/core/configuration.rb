module Fron
  class Configuration
    class App < Component
    end
    class Yield < Component
    end

    attr_accessor :title, :stylesheets, :logger, :injectBlock
    attr_reader :routeBlock, :main, :app

    def initialize
      @app    = App.new
      @main   = Yield.new
      @logger = Fron::Logger.new
    end

    def routes(&block)
      @routeBlock = block
    end

    def layout(&block)
      @app.instance_exec @main, &block
    end

    def layout(&block)
    end

    def customInject(&block)
      @injectBlock = block
    end
  end
end
