# Array extensions
class Array
  # Runs through the elements
  # form the back with index
  #
  # @yieldreturn [*] The item and index
  def reverse_each_with_index
    (0...length).reverse_each do |i|
      yield self[i], i
    end
  end

  # Sort by array in place.
  #
  # @param block [Proc] The block
  #
  # @return [Array] The array
  def sort_by!(&block)
    sort! do |a, b|
      block.call(a) <=> block.call(b)
    end
  end
end
