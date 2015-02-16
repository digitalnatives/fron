module DOM
  # Events module for managing events for elements and element like nodes (SVG Element for example).
  #
  # Features:
  # * Store event listeners for listing and removal
  # * Shorthand *on* and *on!* for non capture / capture
  # * Triggering event dynamically
  module Events
    attr_reader :listeners

    # Triggers an event with the given type and data
    #
    # @param type [String] The type
    # @param data [Hash] The data
    def trigger(type, data = {})
      data = if data.is_a?(Event)
               data.instance_variable_get('@event')
             elsif data.respond_to?(:to_json)
               `JSON.parse(#{data.to_json})`
             end
      %x{
        var event = document.createEvent("HTMLEvents");
        event.initEvent(#{type}, true, true);
        dat = #{data};
        for (key in dat) {
          value = dat[key];
          event[key] = value;
        }
        #{@el}.dispatchEvent(event);
      }
    end

    # Listens on the given type of event with capture
    #
    # @param type [String] The type
    #
    # @yieldparam event [Event] The event
    def on!(type, &listener)
      add_listener type, true, &listener
    end

    # Listens on the given type of event without capture
    #
    # @param type [String] The type
    #
    # @yieldparam event [Event] The event
    def on(type, &listener)
      add_listener type, &listener
    end

    # Removes events
    #
    # * If type and method given removes the exact event
    # * If only type is given removes events with that type
    # * If no arguments are passed removes all attached events
    #
    # @param type [String] The type
    # @param method [Function] The listener returned from *on*
    def off(type = nil, method = nil)
      return unless @listeners

      if type.nil?
        @listeners.keys.each do |ltype|
          remove_listeners ltype
        end
      elsif method.nil?
        remove_listeners type
      else
        return unless @listeners[type].index(method)
        @listeners[type].delete method
        `#{@el}.removeEventListener(#{type},#{method})`
        `#{@el}.removeEventListener(#{type},#{method},true)`
      end
    end

    # Delegates the events with the given type
    # if they match the given selector
    #
    # @param type [String] The type
    # @param selector [type] The selector
    #
    # @yieldparam event [Event] The event
    def delegate(type, selector)
      on type do |event|
        break unless event.target.matches selector
        yield event
      end
    end

    private

    # Adds an event listener for the given type.
    #
    # @param type [String] The type
    # @param capture [Boolean] To use capture or not
    #
    # @return [Function] The native function for later removal
    #
    # @yieldparam event [Event] The event
    def add_listener(type, capture = false)
      method = `function(e){#{ yield Event.new(`e`)}}`

      @listeners       ||= {}
      @listeners[type] ||= []
      @listeners[type] << method

      `#{@el}.addEventListener(#{type},#{method},#{capture})`
      method
    end

    # Removes all events with the given type
    #
    # @param type [String] The type
    def remove_listeners(type)
      @listeners[type].each do |method|
        @listeners[type].delete method
        `#{@el}.removeEventListener(#{type},#{method})`
      end
    end
  end
end
