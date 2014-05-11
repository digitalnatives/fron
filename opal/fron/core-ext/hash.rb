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
end
