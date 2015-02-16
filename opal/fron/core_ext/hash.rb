# Hash
class Hash
  # Converts the hash into an url encoded query string
  #
  # @return [String] the query string
  def to_query_string
    map do |key, value|
      `encodeURIComponent(#{key})+"="+encodeURIComponent(#{value})`
    end.join '&'
  end

  # Converts the hash into a form data object
  #
  # @return [FormData] The native form data object
  def to_form_data
    form_data = `new FormData()`
    each do |key, value|
      `#{form_data}.append(#{key},#{value})`
    end
    form_data
  end

  # Produces a diff hash from self and the other hash
  #
  # @param other [Hash] The other hash
  #
  # @return [Hash] The difference from the other hash
  def deep_diff(other)
    (keys + other.keys).uniq.each_with_object({}) do |key, diff|
      self_key  = self[key]
      other_key = other[key]
      next if self_key == other_key
      if self_key.respond_to?(:deep_diff) && other_key.respond_to?(:deep_diff)
        diff[key] = self_key.deepDiff(other_key)
      else
        diff[key] = [self_key, other_key]
      end
      diff
    end
  end
end
