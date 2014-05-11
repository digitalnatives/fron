module DOM
  class Fragment
    include Node

    def initialize
      @el = `document.createDocumentFragment()`
    end
  end
end
