module DOM
  # File Reader
  class FileReader
    include Events

    def initialize
      @el = `new FileReader()`
    end

    def readAsDataURL(file)
      return unless file
      `#{@el}.readAsDataURL(file.native)`
    end
  end
end
