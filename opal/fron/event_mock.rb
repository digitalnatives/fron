require 'fron/js/syntetic_event'

# Event Mock module for mocking events
module EventMock
  class << self
    # Sets / gets the whether or not
    # log event triggers
    #
    # @param value [Boolean] The verbosity
    # @return [Boolean] The verbosity
    attr_accessor :verbose

    attr_accessor :mock

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
      @mock = true
      yield
    ensure
      @mock = false
    end
  end
end

module DOM
  module Events
    alias_method :old_trigger, :trigger

    def trigger(type, data = {})
      return old_trigger(type, data) if EventMock.mock
      puts "Triggered syntetic event \"#{type}\" for \"#{path}\"" if EventMock.verbose
      EventMock.trigger_event self, type, data
    end
  end
end
