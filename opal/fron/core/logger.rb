module Fron
  # Logger
  class Logger
    # Sets / gets the log level
    #
    # @param level [Symbol] The level
    # @return [Symbol] The level
    attr_accessor :level

    # Initailizes the logger
    def initialize
      @level = :info
    end

    # Logs the given message
    #
    # @param message [String] The message
    def info(message)
      return if ENV == 'test'
      return if @level == :error
      puts Time.now.strftime('[%H:%M] ') + message
    end
  end
end
