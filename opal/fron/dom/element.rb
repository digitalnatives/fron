module DOM
  # Element
  #
  # @todo Describe the element creation ways here
  class Element < NODE
    include ClassList
    include Dimensions

    attr_reader :style

    # Attribute regexp
    ATTRIBUTE_REGEXP   = /\[(.*?)=(.*?)\]/

    # Tag regexp
    TAG_REGEXP         = /(^[A-Za-z_\-0-9]+)(.*)/

    # Modifier regexp
    MODIFIER_REGEXP    = /(#|\.)(.+?)(?=#|\.| |$)/

    # Initializes a new elment based on the data
    #
    # @param data [*] The data
    def initialize(data)
      if `typeof #{data} === 'string'`
        tag, rest = data.match(TAG_REGEXP).to_a[1..2]
        @el = `document.createElement(#{tag})`
        `#{@el}._instance = #{self}`
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
            add_class value
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

    # Returns whether or not the element matches the given selector
    #
    # @param selector [String] The selector
    #
    # @return [Boolean] True if matches false if not
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

    # Hides the element
    def hide
      @style.display = 'none'
    end

    # Shows the element
    def show
      @style.display = ''
    end

    # Returns the value of the attribute with the given name
    #
    # @param name [String] The name of the attribute
    #
    # @return [String] The value
    def [](name)
      `#{@el}.getAttribute(#{name}) || Opal.nil`
    end

    # Sets the value of the attribute with the given name with the given value
    #
    # @param name [String] The name
    # @param value [String] The value
    #
    # @return [type] [description]
    def []=(name, value)
      `#{@el}.setAttribute(#{name},#{value})`
    end

    # Returns the element matching the given selector or nil
    #
    # @param selector [String] The selector
    #
    # @return [DOM::Element] The element
    def find(selector)
      DOM::Element.from_node `#{@el}.querySelector(#{selector}) || Opal.nil`
    end

    # Returns the elements innerHTML
    #
    # @return [String] The html
    def html
      `#{@el}.innerHTML`
    end

    # Sets the elements innerHTML
    #
    # @param value [String] The html
    def html=(value)
      `#{@el}.innerHTML = #{value}`
    end

    # Returns the elements value
    #
    # @return [String] The value
    def value
      `#{@el}.value`
    end

    # Sets the elements value
    #
    # @param value [String] The value
    def value=(value)
      `#{@el}.value = #{value}`
    end

    # Returns the elements checked state
    #
    # @return [Boolean] True if checked false if not
    def checked
      `!!#{@el}.checked`
    end

    # Sets the elements checked state
    #
    # @param value [Boolean] The state
    def checked=(value)
      `#{@el}.checked = #{value}`
    end

    # Returns the disabled innerHTML
    #
    # @return [String] True if disabled false if not
    def disabled
      `#{@el}.disabled`
    end

    # Sets the elements disabled state
    #
    # @param value [Boolean] The state
    def disabled=(value)
      `#{@el}.disabled = #{value}`
    end

    # Focuses the element
    def focus
      `#{@el}.focus()`
    end

    # Return the files of the element
    #
    # @return [Array] The files
    def files
      Native `#{@el}.files`
    end

    # Returns the lowercased tag name of the lement
    #
    # @return [String] The tag name
    def tag
      `#{@el}.tagName`.downcase
    end

    # Returns the id of the element
    #
    # @return [String] The id
    def id
      self['id']
    end

    # Returns the next element sibling
    #
    # @return [DOM::Element] The element
    def next
      DOM::Element.from_node `#{@el}.nextElementSibling || Opal.nil`
    end

    # Returns if the element has the given attribute
    #
    # @param name [String] The attribute
    #
    # @return [Boolean] True / False
    def attribute?(name)
      `#{@el}.hasAttribute(#{name})`
    end

    # Removes the given attribute
    #
    # @param name [String] The attributes name
    def remove_attribute(name)
      `#{@el}.removeAttribute(#{name})`
    end

    # Finds all of the elements matching the selector.
    #
    # @param selector [String] The selector
    #
    # @return [NodeList] The elements
    def find_all(selector)
      DOM::NodeList.new `Array.prototype.slice.call(#{@el}.querySelectorAll(#{selector}))`
    end
  end
end
