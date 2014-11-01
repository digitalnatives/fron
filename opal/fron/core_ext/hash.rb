# Hash
class Hash
  def toQueryString
    map do |key, value|
      `encodeURIComponent(#{key})+"="+encodeURIComponent(#{value})`
    end.join '&'
  end

  def toFormData
    formData = `new FormData()`
    each do |key, value|
      `#{formData}.append(#{key},#{value})`
    end
    formData
  end

  def deepDiff(other)
    (keys + other.keys).uniq.each_with_object({}) do |key, diff|
      if self[key] != other[key]
        if self[key].respond_to?(:deepDiff) && other[key].respond_to?(:deepDiff)
          diff[key] = self[key].deepDiff(other[key])
        else
          diff[key] = [self[key], other[key]]
        end
      end
      diff
    end
  end
end
