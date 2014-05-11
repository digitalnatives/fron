module DOM
  class Text
  	include Node

    def initialize(data)
    	@el = `typeof #{data} === 'string'` ? `document.createTextNode(#{data})` : data
    end
  end
end
