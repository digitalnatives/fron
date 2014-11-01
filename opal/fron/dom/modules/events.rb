module DOM
  # Events
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
      addListener type, true, &listener
    end

    def on(type, &listener)
      addListener type, &listener
    end

    def off(type = nil, method = nil)
      return unless @listeners

      if type.nil?
        @listeners.keys.each do |ltype|
          removeListeners ltype
        end
      elsif method.nil?
        removeListeners type
      else
        return unless @listeners[type].index(method)
        @listeners[type].delete method
        `#{@el}.removeEventListener(#{type},#{method})`
        `#{@el}.removeEventListener(#{type},#{method},true)`
      end
    end

    def delegate(type, selector)
      on type do |event|
        break unless event.target.matches selector
        yield event
      end
    end

    private

    def addListener(type, capture = false)
      klass = if defined? self.class::EVENT_TARGET_CLASS
                self.class::EVENT_TARGET_CLASS
              else
                Hash
              end
      method = `function(e){#{ yield Event.new(`e`, klass)}}`

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
