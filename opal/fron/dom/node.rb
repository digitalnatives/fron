module DOM
  class NODE
    EVENT_TARGET_CLASS = self

    include Events
    include Comparable

    def initialize(node = nil)
      raise "A node must be provided!" unless node
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

    def empty?
      `#{@el}.childNodes.length === 0`
    end

    def children
      NodeList.new `Array.prototype.slice.call(#{@el}.childNodes)`
    end

    # Remove
    # ---------------------------------------
    def remove(el)
      `#{@el}.removeChild(#{getEl el})`
    end

    def remove!
      return unless parent
      parent.remove self
    end

    # Hierarchy Manipulation
    # ---------------------------------------
    def << el
      `#{@el}.appendChild(#{getEl el})`
    end

    def >> el
      `#{getEl el}.appendChild(#{@el})`
    end

    def insertBefore(what,where)
      `#{@el}.insertBefore(#{what},#{where})`
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
    def ==(obj)
      `#{getEl(obj)} === #{@el}`
    end

    def <=>(obj)
      if obj == self then return 0 end
      if obj.parent != parent then raise 'Nodes not Comparable!' end
      obj.index <=> index
    end

    def index
      parent.children.index self
    end

    private

    def getEl(obj)
      obj.is_a?(NODE) ? obj.instance_variable_get('@el') : obj
    end
  end
end
