module Fron
  # Render Proc for rendering efficiently, it uses requestAnimationFrame
  # to limit the number of cycles.
  class RenderProc
    # Initializes a render proc
    #
    # @param method [Method] The method
    # @param verbose [Boolean] Whether or not to log render time
    def initialize(method, verbose, message)
      @running = false
      @method  = method
      @verbose = verbose
      @message = message
    end

    # Runs the proc
    def call
      return if @running
      @running = true
      request_animation_frame do
        time = Time.now
        @method.call
        if @verbose
          message = @message || "Rendered #{@method.owner}"
          logger.info "[#{(Time.now - time) * 1000}ms] #{message}"
        end
        @running = false
      end
    end
  end
end
