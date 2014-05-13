require 'native'

module DOM
  module Dimensions

    def top
      `#{clientRect}.top` + Window.scrollY
    end

    def left
      `#{clientRect}.left` + Window.scrollX
    end

    def right
      `#{clientRect}.right` + Window.scrollX
    end

    def bottom
      `#{clientRect}.bottom` + Window.scrollY
    end

    def width
      `#{clientRect}.width`
    end

    def height
      `#{clientRect}.height`
    end

    private

    def clientRect
      `#{@el}.getBoundingClientRect()`
    end
  end
end
