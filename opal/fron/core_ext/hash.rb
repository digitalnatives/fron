# Hash
class Hash
  # Converts the hash into an url encoded query string
  #
  # @return [String] the query string
  def toQueryString
    map do |key, value|
      `encodeURIComponent(#{key})+"="+encodeURIComponent(#{value})`
    end.join '&'
  end

  # Converts the hash into a form data object
  #
  # @return [FormData] The native form data object
  def toFormData
    formData = `new FormData()`
    each do |key, value|
      `#{formData}.append(#{key},#{value})`
    end
    formData
  end

  # Produces a diff hash from self and the other hash
  #
  # @param other [Hash] The other hash
  #
  # @return [Hash] The difference from the other hash
  def deepDiff(other)
    (keys + other.keys).uniq.each_with_object({}) do |key, diff|
      selfKey  = self[key]
      otherKey = other[key]
      next if selfKey == otherKey
      if selfKey.respond_to?(:deepDiff) && otherKey.respond_to?(:deepDiff)
        diff[key] = selfKey.deepDiff(otherKey)
      else
        diff[key] = [selfKey, otherKey]
      end
      diff
    end
  end
end
