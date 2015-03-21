# Kernel
module Kernel
  # Requests an animation frame from the browser
  # and runs the givel block if given.
  def request_animation_frame
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

  # Shows a prompt window with text and value
  #
  # @param text [String] The text
  # @param value [String] The value
  #
  # @return [String] The user input
  def prompt(text, value)
    `prompt(#{text}, #{value})`
  end

  # Shows an alert window with the given text
  #
  # @param text [String] the text
  def alert(text)
    `alert(#{text})`
  end

  # Shows an confirm window with the given text
  #
  # @param text [String] the text
  #
  # @return [Boolean] True of false depending on user input
  def confirm(text)
    `confirm(#{text})`
  end

  # Clears the timeout with the given ID
  #
  # @param id [Numeric] The ID
  def clear_timeout(id)
    `clearTimeout(#{id})`
  end

  # Returns the logger for the application
  #
  # @return [Fron::Logger] The logger
  def logger
    @logger ||= Fron::Logger.new
  end
end
