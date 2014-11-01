require 'native'

module DOM
  # Node
  class NODE
    EVENT_TARGET_CLASS = self

    include Events
    include Comparable

    # Initializes the node with the given native node
    #
    # @param node [Native] The native node
    def initialize(node = nil)
      fail 'A node must be provided!' unless node
      fail 'Not a HTML Node given!' unless `#{node} instanceof Node`
      @el = node
    end

    # Clones the node without child nodes
    #
    # @return [DOM::NODE] The new node
    def dup
      self.class.new `#{@el}.cloneNode()`
    end

    # Clones the node with child nodes
    #
    # @return [DOM::NODE] The new node
    def dup!
      self.class.new `#{@el}.cloneNode(true)`
    end

    # Returns the parent node
    #
    # @return [DOM::NODE] The parent node
    def parentNode
      el = `#{@el}.parentNode || false`
      el ? DOM::NODE.new(el) : nil
    end

    # Returns the parent element
    #
    # @return [DOM::NODE] The parent element
    def parent
      el = `#{@el}.parentElement || false`
      el ? DOM::NODE.new(el) : nil
    end

    # Removes all the child nodes
    def empty
      children.each { |node| node.remove! }
    end

    # Returns if the node is empty or not
    #
    # @return [Boolean] True if empty false if not
    def empty?
      `#{@el}.childNodes.length === 0`
    end

    # Returns the child nodes as a NodeList
    #
    # @return [DOM::NodeList] The node list
    def children
      NodeList.new `Array.prototype.slice.call(#{@el}.childNodes)`
    end

    # Removes the given elment from the node
    #
    # @param el [DOM::NODE] The element
    def remove(el)
      `#{@el}.removeChild(#{NODE.getElement el})`
    end

    # Removes self from parent node
    def remove!
      return unless parent
      parent.remove self
    end

    # Inserts other node into self
    #
    # @param other [DOM::NODE] The other node
    def <<(other)
      `#{@el}.appendChild(#{NODE.getElement other})`
    end

    # Inserts self into other node
    #
    # @param other [DOM::NODE] The other node
    def >>(other)
      `#{NODE.getElement other}.appendChild(#{@el})`
    end

    # Inserts the given node before the other given node
    #
    # @param what [DOM::NODE] The node to insert
    # @param where [DOM::NODE] The other node
    def insertBefore(what, where)
      return what >> self unless where # Fir for firefox...
      `#{@el}.insertBefore(#{NODE.getElement what},#{NODE.getElement where})`
    end

    # Returns the text content of the node
    #
    # @return [String] The text content
    def text
      `#{@el}.textContent`
    end

    # Sets the text content of the node with the given value
    #
    # @param text [String] The new value
    def text=(text)
      `#{@el}.textContent = #{text}`
    end

    # Normalizes the node removing extra text nodes
    def normalize!
      `#{@el}.normalize()`
    end

    # Compars self with other node
    #
    # @param other [DOM::NODE] Other node
    #
    # @return [Boolean] True if the same false if not
    def ==(other)
      `#{NODE.getElement(other)} === #{@el}`
    end

    # Compars self position with other node
    #
    # @param other [DOM::NODE] Other node
    #
    # @return [Boolean] The compareable with the other node
    def <=>(other)
      return 0 if other == self
      fail 'Nodes not Comparable!' if other.parent != parent
      other.index <=> index
    end

    # Returns the index of the node
    #
    # @return [Numeric] The index
    def index
      parent.children.index self
    end

    # Gets the native node from the given object
    #
    # @param obj [Object] The object
    #
    # @return [Native] The native node
    def self.getElement(obj)
      if `#{obj} instanceof Node`
        obj
      elsif obj.is_a?(NODE)
        obj.instance_variable_get('@el')
      else
        nil
      end
    end
  end
end
