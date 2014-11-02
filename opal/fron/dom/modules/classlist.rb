module DOM
  # ClassList management for DOM::Element
  module ClassList
    # Adds classes to the class list
    #
    # @param classes [Array] The classes
    def addClass(*classes)
      classes.each { |cls| `#{@el}.classList.add(#{cls})` }
    end

    # Removes classes from the class list
    #
    # @param classes [Array] The classes
    def removeClass(*classes)
      classes.each { |cls| `#{@el}.classList.remove(#{cls})` }
    end

    # Returns whether the class list has the given class or not
    #
    # @param cls [String] The class
    #
    # @return [Boolean] True if it has false if not
    def hasClass(cls)
      `#{@el}.classList.contains(#{cls})`
    end

    # Toggles the given class based on the second argument,
    # or if omitted then toggles the class.
    #
    # @param cls [String] The class
    # @param value [Boolean] The value
    def toggleClass(cls, value = nil)
      if value || (value.nil? && !hasClass(cls))
        addClass cls
      else
        removeClass cls
      end
    end
  end
end
