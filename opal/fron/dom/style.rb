class Style
  def initialize(el)
    @el = el
  end

  def method_missing(name,value)
    if name =~ /\=$/
      self[name[0..-2]] = value
    else
      self[name]
    end
  end

  def [](prop)
    `#{@el}.style[#{prop}]`
  end

  def []=(prop,value)
    `#{@el}.style[#{prop}] = #{value}`
  end
end
