module DOM
  # Fragment
  class Fragment < NODE
    def initialize
      @el = `document.createDocumentFragment()`
    end
  end
end
