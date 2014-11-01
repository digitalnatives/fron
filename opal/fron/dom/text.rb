module DOM
  # Text
  class Text < NODE
    # Initializes the text node with the given data
    #
    # @param data [String] The value of the node
    def initialize(data)
      @el = `typeof #{data} === 'string'` ? `document.createTextNode(#{data})` : data
    end
  end
end
