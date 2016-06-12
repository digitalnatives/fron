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
  def sort_by!
    sort! do |a, b|
      yield(a) <=> yield(b)
    end
  end

  def _uniq
    return uniq unless block_given?
    data = uniq
    results = []
    data.reject do |item|
      value = yield item
      next true if results.include? value
      results << value
      false
    end
  end
end
