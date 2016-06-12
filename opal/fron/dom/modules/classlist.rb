module DOM
  # ClassList management for DOM::Element
  module ClassList
    # Adds classes to the class list
    #
    # @param classes [Array] The classes
    def add_class(*classes)
      classes.each { |cls| `#{@el}.classList.add(#{cls})` }
    end

    # Removes classes from the class list
    #
    # @param classes [Array] The classes
    def remove_class(*classes)
      classes.each { |cls| `#{@el}.classList.remove(#{cls})` }
    end

    # Returns whether the class list has the given class or not
    #
    # @param cls [String] The class
    #
    # @return [Boolean] True if it has false if not
    def has_class(cls)
      `#{@el}.classList.contains(#{cls})`
    end

    # Toggles the given class based on the second argument,
    # or if omitted then toggles the class.
    #
    # @param cls [String] The class
    # @param value [Boolean] The value
    def toggle_class(cls, value = nil)
      if value || (value.nil? && !has_class(cls))
        add_class cls
      else
        remove_class cls
      end
    end
  end
end
