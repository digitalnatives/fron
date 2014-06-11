module Kernel
  def requestAnimationFrame(&block)
    return unless `!!window.requestAnimationFrame`
    `window.requestAnimationFrame(function(){ #{block.call} })`
  end

  def timeout(ms = 0,&block)
    `setTimeout(function(){#{block.call}},#{ms})`
  end
end
