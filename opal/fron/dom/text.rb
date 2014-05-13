module DOM
  class Text < NODE
    def initialize(data)
      @el = `typeof #{data} === 'string'` ? `document.createTextNode(#{data})` : data
    end
  end
end
