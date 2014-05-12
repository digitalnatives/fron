module DOM
  module ClassList
    def addClass(*classes)
      classes.each do |cls|
        `#{@el}.classList.add(#{cls})`
      end
    end

    def removeClass(*classes)
      classes.each do |cls|
        `#{@el}.classList.remove(#{cls})`
      end
    end

    def hasClass(cls)
      `#{@el}.classList.contains(#{cls})`
    end

    def toggleClass(cls,value = nil)
      if value || (value == nil && !hasClass(cls))
        addClass cls
      else
        removeClass cls
      end
    end
  end
end
