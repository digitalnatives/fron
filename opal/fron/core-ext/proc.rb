class Proc
  def throttle(ms)
    Native `throttle(#{self},#{ms}, {leading: false})`
  end

  def debounce(ms, leading = false)
    Native `debounce(#{self},#{ms},#{leading})`
  end
end
