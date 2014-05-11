module DOM
  module Document
    def self.head
      find 'head'
    end

    def self.body
      find 'body'
    end

    def self.title=(value)
      `document.title = #{value}`
    end

    def self.find(selector)
      value = `document.querySelector(#{selector}) || false`
      value ? DOM::Element.new(value) : nil
    end
  end
end
