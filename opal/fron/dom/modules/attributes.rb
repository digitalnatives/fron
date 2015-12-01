module DOM
  # Attributes
  module Attributes
    # Returns the value of the attribute with the given name
    #
    # @param name [String] The name of the attribute
    #
    # @return [String] The value
    def [](name)
      `#{@el}.getAttribute(#{name}) || Opal.nil`
    end

    # Sets the value of the attribute with the given name with the given value
    #
    # @param name [String] The name
    # @param value [String] The value
    #
    # @return [type] [description]
    def []=(name, value)
      if value
        `#{@el}.setAttribute(#{name},#{value})`
      else
        remove_attribute name
      end
    end

    # Returns if the element has the given attribute
    #
    # @param name [String] The attribute
    #
    # @return [Boolean] True / False
    def attribute?(name)
      `#{@el}.hasAttribute(#{name})`
    end

    # Removes the given attribute
    #
    # @param name [String] The attributes name
    def remove_attribute(name)
      `#{@el}.removeAttribute(#{name})`
    end
  end
end
