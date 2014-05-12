module DOM
  module Window
    extend Events
    @el = `window`

    def self.hash
      `window.location.hash.slice(1)`
    end

    def self.hash=(value)
      `window.location.hash = #{value}`
    end

    def self.scrollY
      `window.scrollY || document.documentElement.scrollTop`
    end

    def self.scrollX
      `window.scrollX || document.documentElement.scrollTop`
    end
  end
end
