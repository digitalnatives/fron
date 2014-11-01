module DOM
  # File Reader
  class FileReader
    include Events

    # Initialzies the fire reader
    def initialize
      @el = `new FileReader()`
    end

    # Read the given file as data url
    #
    # @param file [Native] The file
    def readAsDataURL(file)
      return unless file
      `#{@el}.readAsDataURL(file.native)`
    end
  end
end
