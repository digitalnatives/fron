module Fron
  # Simple class for point with x and y coordinates.
  class Point
    # Sets / gets the x portion of the point
    #
    # @param value [Numeric] The value
    # @return [Numeric] The value
    attr_accessor :x

    # Sets / gets the y portion of the point
    #
    # @param value [Numeric] The value
    # @return [Numeric] The value
    attr_accessor :y

    # Creates a new instance
    #
    # @param x [Float] The x coordiante
    # @param y [Float] The y coordiante
    def initialize(x = 0, y = 0)
      @x = x
      @y = y
    end

    # Returns the difference from an other point.
    #
    # @param other [Core::Point] The point to caluclate the difference from
    #
    # @return [Core::Point] The difference
    def -(other)
      self.class.new x - other.x, y - other.y
    end

    # Adds two points together
    #
    # @param other [Core::Point] The other point
    #
    # @return [Core::Point] The result
    def +(other)
      self.class.new x + other.x, y + other.y
    end

    # Multiplies the point by given scalar value
    #
    # @param other [Numeric] The scalar value
    #
    # @return [Core::Point] The result
    def *(other)
      self.class.new x * other, y * other
    end

    # Divides the point by given scalar value
    #
    # @param other [Numeric] The scalar value
    #
    # @return [Core::Point] The result
    def /(other)
      self.class.new x / other, y / other
    end

    # Returns the distance between
    # this point and 0, 0
    #
    # @return [Numeric] The distance
    def distance
      Math.sqrt(@x**2 + @y**2)
    end

    # Returns the string representation of the point
    #
    # @return [String] The representation
    def to_s
      "[#{x}, #{y}]"
    end
  end
end
