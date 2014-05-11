module Fron
  class Configuration
    class App < Component
    end
    class Yield < Component
    end

    attr_accessor :title, :stylesheets, :logger
    attr_reader :routeBlock, :main, :app

    def initialize
      @main = Yield.new
      @app = App.new

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
