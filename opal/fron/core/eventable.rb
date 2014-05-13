module Fron
  module Eventable
    extend self

    def on(event, &block)
      @events ||= {}
      @events[event] ||= []
      @events[event] << block
      block
    end

    def trigger(event, triggerGlobal = true)
      return unless @events
      return unless @events[event]
      Eventable.trigger event, false if triggerGlobal && self != Fron::Eventable
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
        @events.keys.each do |key|
          @events.delete key
        end
      end
    end
  end
end
