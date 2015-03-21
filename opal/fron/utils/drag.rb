require 'fron/utils/point'

module Fron
  # Class for dragging with pointer events.
  class Drag
    include Fron::Eventable
    extend  Fron::Eventable

    # @return [DOM::Element] The base of the drag
    attr_reader :base

    # @return [DOM::Element] The documents body
    attr_reader :body

    IS_TOUCH = `'ontouchstart' in window  && !window._phantom`

    if IS_TOUCH
      EVENTS = {
        down: 'touchstart',
        move: 'touchmove',
        up:   'touchend'
      }
    else
      EVENTS = {
        down: 'mousedown',
        move: 'mousemove',
        up:   'mouseup'
      }
    end

    # Creates a new drag instance.
    #
    # @param base [DOM::Element] The element to monitor
    def initialize(base)
      reset
      @base = base
      @body = DOM::Document.body

      @base.on EVENTS[:down] do |event| start(event) end
    end

    # Returns the current difference position
    # from the start position.
    #
    # @return [Fron::Point] The difference
    def diff
      @start_position - @position
    end

    private

    # Runs when dragging starts.
    #
    # @param event [Event] The event
    def start(event)
      return stop if IS_TOUCH && `#{event.touches}.length != 1`

      off if @pos_method

      @position       = position(event)
      @target         = event.target
      @start_position = @position
      @mouse_is_down  = true

      @pos_method = @body.on! EVENTS[:move] do |evt| pos(evt) end
      @up_method  = @body.on! EVENTS[:up]   do |evt| up(evt)  end

      request_animation_frame do move end
    end

    # Runs when the pointer moves starts.
    #
    # @param event [Event] The event
    def pos(event)
      @position = position(event)
      if diff.distance > 7 && !@started
        @started = true
        trigger 'start', @target
      end
      event.stop
    end

    # Stops the drag
    def stop
      off
      reset
    end

    # Runs when pointer releases.
    #
    # @param event [Event] The event
    def up(event)
      off
      trigger 'end' if @started
      reset
      return unless @started
      event.preventDefault
      event.stop
    end

    # Runs on animation frame when the mouse is down.
    def move
      request_animation_frame { move } if @mouse_is_down
      return if !@position || !@started
      trigger 'move', @position
    end

    # Removes event listeners
    def off
      @body.off EVENTS[:move], @pos_method
      @body.off EVENTS[:up],   @up_method
    end

    # Resets the drag
    def reset
      @started         = false
      @target          = nil
      @position        = nil
      @start_position  = nil
      @mouse_is_down   = false
    end

    # Gets the position from the given event.
    # @param event [Event] The event
    #
    # @return [Fron::Point] A point from the event.
    def position(event)
      if IS_TOUCH && event.touches
        Point.new `#{event.touches}[0].pageX`, `#{event.touches}[0].pageY`
      else
        Point.new event.pageX, event.pageY
      end
    end
  end
end
