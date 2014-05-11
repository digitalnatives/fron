module DOM
  class Element < NODE
    include ClassList
    include Dimensions

    attr_reader :style

    ATTRIBUTE_REGEXP = /\[(.*?)=(.*?)\]/
    TAG_REGEXP       = /(^[A-Za-z_\-0-9]+)(.*)/
    MODIFIER_REGEXP  = /(#|\.)(.+?)(?=#|\.| |$)/

    def initialize(data)
      if `typeof #{data} === 'string'`
        match, tag, rest = data.match(TAG_REGEXP).to_a
        @el = `document.createElement(#{tag})`
        rest = rest.gsub ATTRIBUTE_REGEXP do |match|
          m,key,value = match.match(ATTRIBUTE_REGEXP).to_a
          self[key] = value
          ''
        end
        rest = rest.gsub MODIFIER_REGEXP do |match|
          m,type,value = match.match(MODIFIER_REGEXP).to_a
          case type
          when "#"
            self['id'] = value
          when "."
            addClass value
          end
          ''
        end
        if (m = rest.match /\s(.+)$/)
          self.text = m[0].strip
        end
      else
        @el = data
      end
      @style = Style.new @el
    end

    # Visiblity
    # --------------------------------
    def hide
      @style.display = 'none'
    end

    def show
      @style.display = 'block'
    end

    # Attribute access
    # --------------------------------
    def [](name)
      `#{@el}.getAttribute(#{name})`
    end

    def []=(name,value)
      `#{@el}.setAttribute(#{name},#{value})`
    end

    # Traversing
    # --------------------------------
    def find(selector)
      value = `#{@el}.querySelector(#{selector}) || false`
      value ? DOM::Element.new(value) : nil
    end

    # HTML Modification
    # --------------------------------
    def html
      `#{@el}.innerHTML`
    end

    def html=(value)
      `#{@el}.innerHTML = #{value}`
    end

    def empty
      self.html = ''
    end

    def value
      `#{@el}.value`
    end

    def value=(value)
      `#{@el}.value = #{value}`
    end

    def checked
      `!!#{@el}.checked`
    end

    def checked=(value)
      `#{@el}.checked = #{value}`
    end

    def tag
      `#{@el}.tagName`.downcase
    end
  end
end
