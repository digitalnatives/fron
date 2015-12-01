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
      `#{client_rect}.top` + Window.scroll_y
    end

    # Returns the left position of the element
    #
    # @return [Number] The left position
    def left
      `#{client_rect}.left` + Window.scroll_x
    end

    # Returns the right position of the element
    #
    # @return [Number] The right position
    def right
      `#{client_rect}.right` + Window.scroll_x
    end

    # Returns the bottom position of the element
    #
    # @return [Number] The bottom position
    def bottom
      `#{client_rect}.bottom` + Window.scroll_y
    end

    # Returns the width of the element
    #
    # @return [Number] The width
    def width
      `#{client_rect}.width`
    end

    # Returns the height of the element
    #
    # @return [Number] The height
    def height
      `#{client_rect}.height`
    end

    # Returns whether or not the element covers the given position
    #
    # @param pos [Point] The point
    #
    # @return [Boolean] True if covers false if not
    def cover?(pos)
      (left...(left + width)).cover?(pos.x) && (top...(top + height)).cover?(pos.y)
    end

    # Returns if the element is visible or not.
    #
    # The element is visible if:
    # * The size is 0
    #   * display: none
    #   * Element not in the dom
    #   * Width & Height set to 0
    # * It is outside of the viewport
    #
    # The following is not checked because the element is still visible in a sense
    # because it has a width & height but it is transparent.
    # * opacity: 0
    # * visibility: hidden
    #
    # @return [Boolean] True if visible, false if not
    def visible?
      size_visible  = width > 0 && height > 0
      vert_visible  = ((`#{client_rect}.top` + height) > 0) && `#{client_rect}.top` < `window.innerHeight`
      horiz_visible = ((`#{client_rect}.left` + width) > 0) && `#{client_rect}.left` < `window.innerWidth`

      size_visible && vert_visible && horiz_visible
    end

    private

    # Gets the bounding client rect of element.
    #
    # @return [Hash] The rect
    def client_rect
      `#{@el}.getBoundingClientRect()`
    end
  end
end
