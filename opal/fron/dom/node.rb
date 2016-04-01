require 'native'

module DOM
  # Low level wrapper for the Node class
  #
  # :reek:TooManyMethods
  class NODE
    include Events
    include Comparable

    # Returns the ruby instance associated to the node,
    # or creates a new instance if there is none.
    #
    # @param node [Native] The node
    #
    # @return [DOM::NODE] The ruby node
    def self.from_node(node)
      return nil unless node
      instance = `#{node}._instance || Opal.nil`
      return instance if instance && instance.is_a?(DOM::NODE)
      new node
    end

    # Initializes the node with the given native node
    #
    # @param node [Native] The native node
    def initialize(node = nil)
      raise 'A node must be provided!' unless node
      raise 'Not a HTML Node given!' unless `#{node} instanceof Node`
      @el = node
      `#{@el}._instance = #{self}`
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
    def parent_node
      DOM::Element.from_node `#{@el}.parentNode || Opal.nil`
    end

    # Returns the parent element
    #
    # @return [DOM::NODE] The parent element
    def parent
      DOM::Element.from_node `#{@el}.parentElement || Opal.nil`
    end

    # Removes all the child nodes
    def empty
      children.each(&:remove!)
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
      `#{@el}.removeChild(#{NODE.get_element el})`
      trigger :domchange
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
      `#{@el}.appendChild(#{NODE.get_element other})`
      trigger :domchange
    end

    # Inserts self into other node
    #
    # @param other [DOM::NODE] The other node
    def >>(other)
      `#{NODE.get_element other}.appendChild(#{@el})`
      trigger :domchange
    end

    # Inserts the given node before the other given node
    #
    # @param what [DOM::NODE] The node to insert
    # @param where [DOM::NODE] The other node
    def insert_before(what, where)
      return what >> self unless where # Fix for firefox...
      `#{@el}.insertBefore(#{NODE.get_element what},#{NODE.get_element where})`
      trigger :domchange
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
      `#{NODE.get_element(other)} === #{@el}`
    end

    # Compars self position with other node
    #
    # @param other [DOM::NODE] Other node
    #
    # @return [Boolean] The compareable with the other node
    def <=>(other)
      return 0 if other == self
      raise 'Nodes not Comparable!' if other.parent != parent
      other.index <=> index
    end

    # Returns the index of the node
    #
    # @return [Integer] Zero based index
    def index
      return nil unless parent
      NodeList.new(`Array.prototype.slice.call(#{@el}.parentNode.children)`).index self
    end

    # Gets the native node from the given object
    #
    # @param obj [Object] The object
    #
    # @return [Native] The native node
    def self.get_element(obj)
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
