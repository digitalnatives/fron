module DOM
  # Fragment
  class Fragment < NODE
    # Initializes the document fragment
    def initialize
      @el = `document.createDocumentFragment()`
    end
  end
end
