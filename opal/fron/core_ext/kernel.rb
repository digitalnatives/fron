# Kernel
module Kernel
  def requestAnimationFrame
    return unless `!!window.requestAnimationFrame`
    `window.requestAnimationFrame(function(){ #{yield} })`
  end

  def timeout(ms = 0)
    `setTimeout(function(){#{yield}},#{ms})`
  end
end
