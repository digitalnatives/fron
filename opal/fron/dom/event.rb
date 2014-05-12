class Event
  def initialize(e)
    @e = e
  end

  def target
    DOM::Element.new `#{@e}.target`
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
    `#{@e}.altkey`
  end

  def shift?
    `#{@e}.shiftkey`
  end

  def ctrl?
    `#{@e}.ctrlkey`
  end

  def meta?
    `#{@e}.metakey`
  end
end
