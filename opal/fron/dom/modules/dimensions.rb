require 'native'

module DOM
  # Dimensions module for returning node like elements position on the screen.
  #
  # Features:
  # * Accessors for *top*, *left*, *right*, *bottom*, width and height
  # * Positions are compensated with *scroll* *position*
  module Dimensions
    # Returns the top position of the element
    #
    # @return [Number] The top position
    def top
      `#{clientRect}.top` + Window.scrollY
    end

    # Returns the left position of the element
    #
    # @return [Number] The left position
    def left
      `#{clientRect}.left` + Window.scrollX
    end

    # Returns the right position of the element
    #
    # @return [Number] The right position
    def right
      `#{clientRect}.right` + Window.scrollX
    end

    # Returns the bottom position of the element
    #
    # @return [Number] The bottom position
    def bottom
      `#{clientRect}.bottom` + Window.scrollY
    end

    # Returns the width of the element
    #
    # @return [Number] The width
    def width
      `#{clientRect}.width`
    end

    # Returns the height of the element
    #
    # @return [Number] The height
    def height
      `#{clientRect}.height`
    end

    private

    # Gets the bounding client rect of element.
    #
    # @return [Hash] The rect
    def clientRect
      `#{@el}.getBoundingClientRect()`
    end
  end
end
