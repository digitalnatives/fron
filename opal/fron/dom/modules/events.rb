module DOM
  module Events
    attr_reader :listeners

    def trigger(type, data = {})
      %x{
        var event = document.createEvent("HTMLEvents");
        event.initEvent(#{type}, true, true);
        for (key in #{data}) {
          value = #{data}[key];
          event[key] = value;
        }
        #{@el}.dispatchEvent(event);
      }
    end

    def on!(type, &listener)
      _on type, true, &listener
    end

    def on(type, &listener)
      _on type, &listener
    end

    def off(type = nil, method = nil)
      return unless @listeners

      if type == nil
        @listeners.keys.each do |ltype|
          removeListeners ltype
        end
      elsif method == nil
        removeListeners type
      else
        return unless @listeners[type].index(method)
        @listeners[type].delete method
        `#{@el}.removeEventListener(#{type},#{method})`
        `#{@el}.removeEventListener(#{type},#{method},true)`
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

    def _on(type, capture = false, &listener)
      klass = if defined? self.class::EVENT_TARGET_CLASS
                self.class::EVENT_TARGET_CLASS
              else
                Hash
              end
      method = `function(e){#{ listener.call Event.new(`e`,klass)}}`

      @listeners       ||= {}
      @listeners[type] ||= []
      @listeners[type] << method

      `#{@el}.addEventListener(#{type},#{method},#{capture})`
      method
    end

    def removeListeners(type)
      @listeners[type].each do |method|
        @listeners[type].delete method
        `#{@el}.removeEventListener(#{type},#{method})`
      end
    end
  end
end
