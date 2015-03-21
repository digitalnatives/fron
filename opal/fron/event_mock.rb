require 'fron/js/syntetic_event'

# Event Mock module for mocking events
module EventMock
  class << self
    attr_accessor :verbose

    # Triggers a syntetic event.
    #
    # @param element [DOM::Element] The element
    # @param type [String] Event type
    # @param data [Hash] The data for the event
    def trigger_event(element, type, data = {})
      event = `new SynteticEvent(#{element.instance_variable_get('@el')}, #{data.to_n})`
      dispath_event element, event, type
    end

    # Dispatches a sytetic event
    #
    # @param element [DOM::Element] The element
    # @param event [SynteticEvent] The event
    # @param type [String] Event type
    #
    # @return [type] [description]
    def dispath_event(element, event, type)
      if `#{element.listeners} || Opal.nil`
        element.listeners[type].to_a.each do |method|
          break unless `#{event}.immediatePropagate`
          method.call event
        end
      end
      return unless `#{event}.propagate`
      return unless element.parent
      dispath_event element.parent, event, type
    end

    # Mocks triggers on DOM::Events
    def mock_events
      DOM::Events.alias_method :old_trigger, :trigger
      DOM::Events.define_method :trigger do |type, data = {}|
        puts "Triggered syntetic event \"#{type}\" for \"#{path}\"" if EventMock.verbose
        EventMock.trigger_event self, type, data
      end
      yield
    ensure
      DOM::Events.alias_method :trigger, :old_trigger
    end
  end
end
