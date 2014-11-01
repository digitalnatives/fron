require 'native'

module DOM
  # Node
  class NODE
    EVENT_TARGET_CLASS = self

    include Events
    include Comparable

    def initialize(node = nil)
      fail 'A node must be provided!' unless node
      fail 'Not a HTML Node given!' unless `#{node} instanceof Node`
      @el = node
    end

    # Cloning
    # ---------------------------------------
    def dup
      self.class.new `#{@el}.cloneNode()`
    end

    def dup!
      self.class.new `#{@el}.cloneNode(true)`
    end

    # Hierarchy
    # ---------------------------------------
    def parentNode
      el = `#{@el}.parentNode || false`
      el ? DOM::NODE.new(el) : nil
    end

    def parent
      el = `#{@el}.parentElement || false`
      el ? DOM::NODE.new(el) : nil
    end

    def empty
      children.each { |node| node.remove! }
    end

    def empty?
      `#{@el}.childNodes.length === 0`
    end

    def children
      NodeList.new `Array.prototype.slice.call(#{@el}.childNodes)`
    end

    # Remove
    # ---------------------------------------
    def remove(el)
      `#{@el}.removeChild(#{NODE.getElement el})`
    end

    def remove!
      return unless parent
      parent.remove self
    end

    # Hierarchy Manipulation
    # ---------------------------------------
    def <<(other)
      `#{@el}.appendChild(#{NODE.getElement other})`
    end

    def >>(other)
      `#{NODE.getElement other}.appendChild(#{@el})`
    end

    def insertBefore(what, where)
      return what >> self unless where # Fir for firefox...
      `#{@el}.insertBefore(#{NODE.getElement what},#{NODE.getElement where})`
    end

    # Text manipulation
    # ---------------------------------------
    def text
      `#{@el}.textContent`
    end

    def text=(text)
      `#{@el}.textContent = #{text}`
    end

    def normalize!
      `#{@el}.normalize()`
    end

    # Comparabe methods
    # ---------------------------------------
    def ==(other)
      `#{NODE.getElement(other)} === #{@el}`
    end

    def <=>(other)
      return 0 if other == self
      fail 'Nodes not Comparable!' if other.parent != parent
      other.index <=> index
    end

    def index
      parent.children.index self
    end

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
