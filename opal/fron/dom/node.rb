module DOM
  class NODE
    include Events

    def initialize(node = nil)
      raise "A node must be provided" unless node
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
      DOM::NODE.new `#{@el}.parentNode`
    end

    def parent
      DOM::NODE.new `#{@el}.parentElement`
    end

    def empty?
      `#{@el}.childNodes.length === 0`
    end

    def children
      `Array.prototype.slice.call(#{@el}.childNodes)`
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
      self
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

    def normalize
      `#{@el}.normalize()`
    end

    private

    def getEl(obj)
      obj.is_a?(NODE) ? obj.instance_variable_get('@el') : obj
    end
  end
end
