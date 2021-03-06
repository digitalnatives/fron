module DOM
  # Element accessor methods
  module ElementAccessor
    # Defines a method that is delegated to the
    # underlying element.
    #
    # @param method [Symbol] The name of the method
    def element_method(method)
      define_method method do
        `#{@el}[#{method}]()`
      end
    end

    # Defines a attributes accessor that is delegated to the
    # underlying elements gieven attribute.
    #
    # Options:
    # * **as** - Use this instead of the attribute as identifier
    # * **default** - Return this value if the attribute is null or undefined
    # * **coerce** - Coerse the string value of the attribute with this method
    #
    # @param attribute [Symbol] The attribute
    # @param options [Hash] The options
    def attribute_accessor(attribute, options = {})
      options = { as: attribute, default: nil, coerce: nil }.merge!(options)

      define_method options[:as] do
        value = self[attribute] || options[:default]
        next value unless options[:coerce]
        value.send(options[:coerce])
      end

      define_method "#{options[:as]}=" do |value|
        self[attribute] = value
        send('_attribute_changed', attribute, value) if respond_to?(:_attribute_changed)
      end
    end

    # Defines a property accessor that is delegated to the
    # underlying element.
    #
    # Options:
    # * **as** - Use this instead of the property as identifier
    # * **default** - Return this value if the property is null or undefined
    #
    # @param property [Symbol] The property
    # @param options [Hash] The options
    def element_accessor(property, options = {})
      options = { as: property, default: nil }.merge!(options)

      define_method options[:as] do
        `#{@el}[#{property}] || #{options[:default]}`
      end

      define_method "#{options[:as]}=" do |value|
        `#{@el}[#{property}] = #{value}`
      end
    end
  end
end
