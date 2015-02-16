module DOM
  # Window
  module Window
    extend Events
    @el = `window`

    # Sets the url via pushState
    #
    # @param url [String] The url
    def self.state=(url)
      return if url == state
      `window.history.pushState({},'',#{url})`
      timeout { trigger 'popstate' }
    end

    # Returns the locations pathname as state
    #
    # @return [String] The pathname
    def self.state
      `window.location.pathname`
    end

    # Returns the locations hash
    #
    # @return [String] The hash
    def self.hash
      `window.location.hash.slice(1)`
    end

    # Sets the locations hash with the given value
    #
    # @param value [String] The value
    def self.hash=(value)
      `window.location.hash = #{value}`
    end

    # Returns the Y scroll position of the window
    #
    # @return [Numeric] The position
    def self.scroll_y
      `window.scrollY || document.documentElement.scrollTop`
    end

    # Returns the X scroll position of the window
    #
    # @return [Numeric] The position
    def self.scroll_x
      `window.scrollX || document.documentElement.scrollTop`
    end
  end
end
