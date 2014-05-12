module Fron
  class Configuration
    class App < Component
    end
    class Yield < Component
    end

    attr_accessor :title, :stylesheets, :logger
    attr_reader :routeBlock, :main, :app

    def initialize
      @app    = App.new
      @main   = Yield.new
      @logger = Fron::Logger.new

      DOM::Document.body.empty
    end

    def routes(&block)
      @routeBlock = block
    end

    def layout(&block)
      @app.instance_exec @main, &block
    end
  end
end
