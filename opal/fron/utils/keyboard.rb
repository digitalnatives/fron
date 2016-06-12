module Fron
  # Keyboard class that handles matcing keyp presses to shortcuts.
  class Keyboard
    class << self
      # @return [Array] The data for the shortcuts
      attr_reader :shortcuts

      # Delimeters to separate shortcut parts
      DELIMETERS = /-|\+|:|_/

      # Defines a shortcut. If a block given it will run that block on a match
      # and not the action. Otherwise it will run the action named method on
      # the instance.
      #
      # The shortcut order is not relevant, and it can have many delimiters.
      #
      # Exmaple shortcuts:
      # * ctrl+click
      # * ctrl:up
      # * ctrl-down
      # * ctrl-shift_up
      #
      # @param shortcut [String] The shortcut
      # @param action [Symbol] The action to run
      # @param block [Proc] The block to run
      def sc(shortcut, action = nil, &block)
        @shortcuts ||= []
        @shortcuts << { parts: shortcut.split(DELIMETERS), action: action, block: block }
      end
    end

    # Create a new instance
    def initialize
      DOM::Document.body.on 'keydown' do |event| keydown event end
    end

    # Handles keydown event, and shortcut matching.
    #
    # @param event [DOM::Event] The event
    def keydown(event)
      return if DOM::Document.active_element

      combo = Keyboard.calculate_shortcut event

      self.class.shortcuts.each do |shortcut|
        next unless shortcut[:parts].sort == combo.sort
        handle_shortcut shortcut
        event.stop
        break
      end
    end

    def self.calculate_shortcut(event)
      combo = [event.key]
      combo << 'ctrl'  if event.ctrl?
      combo << 'shift' if event.shift?
      combo << 'alt'   if event.alt?
      combo << 'meta'  if event.meta?
      combo.uniq
    end

    # Handles the shortcut.
    #
    # @param shortcut [Hash] The shortcut
    def handle_shortcut(shortcut)
      action = shortcut[:action]
      return instance_exec(&shortcut[:block]) if shortcut[:block]
      return send(action) if respond_to? action
      warn self.class.name + " - shortcut #{shortcut[:parts].join('+')}:#{action} is not implemented!"
    end
  end
end
