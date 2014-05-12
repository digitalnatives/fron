module DOM
  module Events
    def trigger(type, data = {})
      %x{
        event = document.createEvent("HTMLEvents");
        event.initEvent(#{type}, true, true);
        for (key in #{data}) {
          value = #{data}[key];
          event[key] = value;
        }
        #{@el}.dispatchEvent(event);
      }
    end

    def on(type, &listener)
      klass = if defined? self.class::EVENT_TARGET_CLASS
        self.class::EVENT_TARGET_CLASS
      else
        Hash
      end
      method = `function(e){#{ listener.call Event.new(`e`,klass)}}`

      @listeners       ||= {}
      @listeners[type] ||= []
      @listeners[type] << method

      `#{@el}.addEventListener(#{type},#{method})`
      method
    end

    def off(type = nil, method = nil)
      return unless @listeners

      if type == nil
        @listeners.keys.each do |type|
          removeListeners type
        end
      elsif method == nil
        removeListeners type
      else
        return unless @listeners[type].index(method)
        @listeners[type].delete method
        `#{@el}.removeEventListener(#{type},#{method})`
      end
    end

    def delegate(type,selector, &listener)
      on type do |event|
        if event.target.matches selector
          listener.call event
        end
      end
    end

    private

    def removeListeners(type)
      @listeners[type].each do |method|
        @listeners[type].delete method
        `#{@el}.removeEventListener(#{type},#{method})`
      end
    end
  end
end
