module LocalStorage
  def self.get(key)
    value = `window.localStorage.getItem(#{key}) || false`
    value ? JSON.parse(value) : nil
  end

  def self.set(key, data)
    `window.localStorage.setItem(#{key},#{data.to_json})`
  end

  def self.keys
    `ret = []; for (var key in localStorage){ ret.push(key) }; return ret;`
  end

  def self.all
    self.keys.map{ |key| self.get key }
  end
end
