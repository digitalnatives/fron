module DOM
  # This module is a wrapper for the native *document* object.
  module Document
    extend SingleForwardable
    @doc = DOM::Element.new `document`

    def_delegators :@doc, :find

    # Returns the active element
    #
    # @return [DOM::Element] The element
    def self.activeElement
      find ':focus'
    end

    # Returns the head element
    #
    # @return [DOM::Element] The head element
    def self.head
      @head ||= find 'head'
    end

    # Returns the body element
    #
    # @return [DOM::Element] The body element
    def self.body
      @body ||= find 'body'
    end

    # Returns the documents title
    #
    # @return [String] The title
    def self.title
      `document.title`
    end

    # Sets the documents title with the given value
    #
    # @param value [String] The title
    def self.title=(value)
      `document.title = #{value}`
    end
  end
end
