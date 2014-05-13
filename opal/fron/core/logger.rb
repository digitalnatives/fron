module Fron
  class Logger
    attr_accessor :level

    def initialize
      @level = :info
    end

    def info(message)
      return if ENV == 'test'
      return if @level == :error
      puts Time.now.strftime("[%H:%M] ") + message
    end
  end
end
