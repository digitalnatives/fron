class Hash
  def to_query_string
    r = []
    each do |key,value|
      r << `encodeURIComponent(#{key})+"="+encodeURIComponent(#{value})`
    end
    r.join "&"
  end

  def to_form_data
    r = `new FormData()`
    each do |key,value|
      `r.append(#{key},#{value})`
    end
    r
  end

  def deepDiff(b)
    a = self
    (a.keys + b.keys).uniq.inject({}) do |diff, k|
      if a[k] != b[k]
        if a[k].respond_to?(:deepDiff) && b[k].respond_to?(:deepDiff)
          diff[k] = a[k].deepDiff(b[k])
        else
          diff[k] = [a[k], b[k]]
        end
      end
      diff
    end
  end
end
