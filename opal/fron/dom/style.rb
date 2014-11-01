# rubocop:disable MethodName

module DOM
  # Style
  class Style
    # Initializes the style
    #
    # @param el [DOM::Element] The element
    def initialize(el)
      @el = el
    end

    # Sets or gets a given CSS property
    #
    # @param name [String] The property
    # @param value [String] The value
    #
    # @return [String] The value of the property
    def method_missing(name, value)
      if name =~ /\=$/
        self[name[0..-2]] = value
      else
        self[name]
      end
    end

    # Gets a CSS property value
    #
    # @param prop [String] The property
    #
    # @return [String] The value of the property
    def [](prop)
      `#{@el}.style[#{prop}]`
    end

    # Sets the given CSS property with the given value
    #
    # @param prop [String] The property
    # @param value [String] The value
    def []=(prop, value)
      `#{@el}.style[#{prop}] = #{value}`
    end
  end
end
