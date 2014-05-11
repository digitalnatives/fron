module Fron
  class Logger
    def info(message)
      return if ENV == 'test'
      puts Time.now.strftime("[%H:%M] ") + message
    end
  end
end
