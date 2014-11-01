module Fron
  # Configuration
  class Configuration
    # App component
    class App < Component
    end

    # Yield component
    class Yield < Component
    end

    attr_accessor :title, :stylesheets, :logger, :injectBlock
    attr_reader :routeBlock, :main, :app

    # Initializes the configuration
    def initialize
      @app    = App.new
      @main   = Yield.new
      @logger = Fron::Logger.new
    end

    # Sets the route block
    #
    # @param block [Proc] The block
    def routes(&block)
      @routeBlock = block
    end

    # Sets the layout block
    #
    # @param block [Proc] The block
    def layout(&block)
      @app.instance_exec @main, &block
    end

    # Sets the custom injection block
    #
    # @param block [Proc] The block
    def customInject(&block)
      @injectBlock = block
    end
  end
end
