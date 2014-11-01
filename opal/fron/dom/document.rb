module DOM
  # Document
  module Document
    def self.activeElement
      find ':focus'
    end

    def self.head
      @head ||= find 'head'
    end

    def self.body
      @body ||= find 'body'
    end

    def self.title
      `document.title`
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
