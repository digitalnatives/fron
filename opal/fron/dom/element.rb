module DOM
  # Element
  class Element < NODE
    include ClassList
    include Dimensions

    attr_reader :style

    EVENT_TARGET_CLASS = self
    ATTRIBUTE_REGEXP   = /\[(.*?)=(.*?)\]/
    TAG_REGEXP         = /(^[A-Za-z_\-0-9]+)(.*)/
    MODIFIER_REGEXP    = /(#|\.)(.+?)(?=#|\.| |$)/

    def initialize(data)
      if `typeof #{data} === 'string'`
        tag, rest = data.match(TAG_REGEXP).to_a[1..2]
        @el = `document.createElement(#{tag})`
        rest = rest.gsub ATTRIBUTE_REGEXP do |match|
          key, value = match.match(ATTRIBUTE_REGEXP).to_a[1..2]
          self[key] = value
          ''
        end
        rest = rest.gsub MODIFIER_REGEXP do |match|
          type, value = match.match(MODIFIER_REGEXP).to_a[1..2]
          case type
          when '#'
            self['id'] = value
          when '.'
            addClass value
          end
          ''
        end
        if (match = rest.match(/\s(.+)$/))
          self.text = match[0].strip
        end
      else
        super data
      end
      @style = Style.new @el
    end

    def matches(selector)
      %x{
        var proto = Element.prototype
        var matches = proto.matchesSelector ||
        proto.mozMatchesSelector ||
        proto.msMatchesSelector ||
        proto.oMatchesSelector ||
        proto.webkitMatchesSelector
        return matches.call(#{@el},#{selector})
      }
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

    def []=(name, value)
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

    def disabled
      `#{@el}.disabled`
    end

    def disabled=(value)
      `#{@el}.disabled = #{value}`
    end

    def focus
      `#{@el}.focus()`
    end

    def files
      Native `#{@el}.files`
    end

    def tag
      `#{@el}.tagName`.downcase
    end

    def id
      self['id']
    end
  end
end
