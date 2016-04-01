# rubocop:disable ModuleFunction

module Fron
  # Class for adding events to any Ruby object.
  module Eventable
    extend self

    # Add an event listener
    #
    # @param event [String] The type of the event
    # @param block [Proc] The listener body
    #
    # @return [Proc] The block
    def on(event, &block)
      @events ||= {}
      @events[event] ||= []
      @events[event] << block
      block
    end

    # Triggers an event
    #
    # @param event [String] The type of the event
    # @param data = {} [type] The data
    # @param triggerGlobal [Boolean] Whether or not to trigger a global event
    def trigger(event, data = {}, trigger_global = true)
      return unless @events
      return unless @events[event]
      Eventable.trigger event, data, false if trigger_global && self != Fron::Eventable
      @events[event].each do |block|
        block.call data
      end
    end

    # Removes event listeners
    #
    # @param event [String] The type of the event
    # @param block [Proc] The listener body
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
