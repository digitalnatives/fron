# Kernel
module Kernel
  # Requests an animation frame from the browser
  # and runs the givel block if given.
  def requestAnimationFrame
    return unless block_given?
    return unless `!!window.requestAnimationFrame`
    `window.requestAnimationFrame(function(){ #{yield} })`
  end

  # Runs the given block after the given number of milliseconds.
  #
  # @param ms [Integer] The milliseconds
  def timeout(ms = 0)
    `setTimeout(function(){#{yield}},#{ms})`
  end
end
