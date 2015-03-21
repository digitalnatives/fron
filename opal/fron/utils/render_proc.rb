module Fron
  # Render Proc for rendering efficiently, it uses requestAnimationFrame
  # to limit the number of cycles.
  class RenderProc
    # Initializes a render proc
    #
    # @param method [Method] The method
    # @param verbose [Boolean] Whether or not to log render time
    def initialize(method, verbose)
      @running = false
      @method  = method
      @verbose = verbose
    end

    # Runs the proc
    def call
      return if @running
      @running = true
      request_animation_frame do
        time = Time.now
        @method.call
        logger.info "Rendered #{@method.owner} in #{(Time.now - time) * 1000}ms" if @verbose
        @running = false
      end
    end
  end
end
