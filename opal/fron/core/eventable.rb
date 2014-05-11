module Fron
  module Eventable
    extend self

    def on(event, &block)
      @events ||= {}
      @events[event] ||= []
      @events[event] << block
    end

    def trigger(event, triggerGlobal = true)
      Eventable.trigger event, false if triggerGlobal
      return unless @events
      return unless @events[event]
      @events[event].each do |block|
        block.call
      end
    end

    def off(event = nil, &block)
      return unless @events
      if block_given?
        @events[event].delete block
      elsif event
        @events[event] = []
      else
        @events = {}
      end
    end
  end
end
