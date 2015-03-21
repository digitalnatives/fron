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
