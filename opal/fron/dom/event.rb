module DOM
  class Event
    def initialize(e,targetClass)
      @e = e
      @targetClass = targetClass
    end

    def target
      @targetClass.new `#{@e}.target`
    end

    def charCode
      `#{@e}.charCode`
    end

    def keyCode
      `#{@e}.keyCode`
    end

    def stop
      preventDefault
      stopPropagation
    end

    def preventDefault
      `#{@e}.preventDefault()`
    end

    def stopPropagation
      `#{@e}.stopPropagation()`
    end

    def pageX
      `#{@e}.pageX`
    end

    def pageY
      `#{@e}.pageY`
    end

    def screenX
      `#{@e}.screenX`
    end

    def screenY
      `#{@e}.screenY`
    end

    def clientX
      `#{@e}.clientX`
    end

    def clientY
      `#{@e}.clientY`
    end

    def alt?
      `#{@e}.altKey`
    end

    def shift?
      `#{@e}.shiftKey`
    end

    def ctrl?
      `#{@e}.ctrlKey`
    end

    def meta?
      `#{@e}.metaKey`
    end
  end
end
