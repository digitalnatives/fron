module DOM
  # Element
  #
  # TODO: Describe the element creation ways here
  class Element < NODE
    extend ElementAccessor

    include Attributes
    include ClassList
    include Dimensions

    # @return [Style] The style object
    attr_reader :style

    # Attribute regexp
    ATTRIBUTE_REGEXP   = /\[(.*?)=(.*?)\]/

    # Tag regexp
    TAG_REGEXP         = /(^[A-Za-z_\-0-9]+)(.*)/

    # Modifier regexp
    MODIFIER_REGEXP    = /(#|\.)(.+?)(?=#|\.| |$)/

    element_accessor :src
    element_accessor :value
    element_accessor :innerHTML, as: :html

    element_accessor :readonly,        default: false
    element_accessor :checked,         default: false
    element_accessor :disabled,        default: false
    element_accessor :spellcheck,      default: false
    element_accessor :contentEditable, default: false, as: :contenteditable

    element_accessor :scrollTop, as: :scroll_top, default: 0
    element_accessor :scrollLeft, as: :scroll_left, default: 0
    element_accessor :scrollWidth, as: :scroll_width, default: 0
    element_accessor :scrollHeight, as: :scroll_height, default: 0

    element_method :focus
    element_method :blur

    attribute_accessor :tabindex, default: nil

    # Initializes a new elment based on the data
    #
    # @param data [*] The data
    def initialize(data)
      if `typeof #{data} === 'string'`
        tag, rest = data.match(TAG_REGEXP).to_a[1..2]
        @el = `document.createElement(#{tag})`
        `#{@el}._instance = #{self}`

        rest = apply_attributes rest
        rest = apply_modifiers rest

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

    # Returns the element matching the given selector or nil
    #
    # @param selector [String] The selector
    #
    # @return [DOM::Element] The element
    def find(selector)
      DOM::Element.from_node `#{@el}.querySelector(#{selector}) || Opal.nil`
    end

    # Finds all of the elements matching the selector.
    #
    # @param selector [String] The selector
    #
    # @return [NodeList] The elements
    def find_all(selector)
      DOM::NodeList.new `Array.prototype.slice.call(#{@el}.querySelectorAll(#{selector}))`
    end

    # Returns the next element sibling
    #
    # @return [DOM::Element] The element
    def next
      DOM::Element.from_node `#{@el}.nextElementSibling || Opal.nil`
    end

    # Returns the previous element sibling
    #
    # @return [DOM::Element] The element
    def previous
      DOM::Element.from_node `#{@el}.previousElementSibling || Opal.nil`
    end

    # Returns whether or not the given node
    # is inside the node.
    #
    # @param other [DOM::NODE] The other node
    #
    # @return [Boolean] True if contains false if not
    def include?(other)
      `#{@el}.contains(#{DOM::NODE.get_element(other)})` || other == self
    end

    # Returns the path of the elemnt
    #
    # @return [String] The path
    def path
      element = self
      items = [element.tag]
      while element.parent
        items.unshift element.parent.tag
        element = element.parent
      end
      items.join ' '
    end

    # Gets the z-index of the element
    #
    # @return [Number] The z-index
    def z_index
      `getComputedStyle(#{@el}).zIndex`.to_i
    end

    private

    # Applies attributes from the given string.
    #
    # @param string [String] The string
    #
    # @return [String] The string without the attributes
    def apply_attributes(string)
      string.gsub ATTRIBUTE_REGEXP do |match|
        key, value = match.match(ATTRIBUTE_REGEXP).to_a[1..2]
        self[key] = value
        ''
      end
    end

    # Applies modifiers from the given string.
    #
    # @param string [String] The string
    #
    # @return [String] The string without the modifiers
    def apply_modifiers(string)
      string.gsub MODIFIER_REGEXP do |match|
        type, value = match.match(MODIFIER_REGEXP).to_a[1..2]
        case type
        when '#'
          self['id'] = value
        when '.'
          add_class value
        end
        ''
      end
    end
  end
end
