# rubocop:disable MethodName
module DOM
  # Event
  class Event
    # Special keys for converions
    SPECIAL_KEYS = {
      8 => 'backspace',
      9 => 'tab',
      12 => 'num',
      13 => 'enter',
      16 => 'shift',
      17 => 'ctrl',
      18 => 'alt',
      19 => 'pause',
      20 => 'capslock',
      27 => 'esc',
      32 => 'space',
      33 => 'pageup',
      34 => 'pagedown',
      35 => 'end',
      36 => 'home',
      37 => 'left',
      38 => 'up',
      39 => 'right',
      40 => 'down',
      44 => 'print',
      45 => 'insert',
      46 => 'delete',
      48 => '0',
      49 => '1',
      50 => '2',
      51 => '3',
      52 => '4',
      53 => '5',
      54 => '6',
      55 => '7',
      56 => '8',
      57 => '9',
      65 => 'a',
      66 => 'b',
      67 => 'c',
      68 => 'd',
      69 => 'e',
      70 => 'f',
      71 => 'g',
      72 => 'h',
      73 => 'i',
      74 => 'j',
      75 => 'k',
      76 => 'l',
      77 => 'm',
      78 => 'n',
      79 => 'o',
      80 => 'p',
      81 => 'q',
      82 => 'r',
      83 => 's',
      84 => 't',
      85 => 'u',
      86 => 'v',
      87 => 'w',
      88 => 'x',
      89 => 'y',
      90 => 'z',
      91 => 'cmd',
      92 => 'cmd',
      93 => 'cmd',
      96 => 'num_0',
      97 => 'num_1',
      98 => 'num_2',
      99 => 'num_3',
      100 => 'num_4',
      101 => 'num_5',
      102 => 'num_6',
      103 => 'num_7',
      104 => 'num_8',
      105 => 'num_9',
      106 => 'multiply',
      107 => 'add',
      108 => 'enter',
      109 => 'subtract',
      110 => 'decimal',
      111 => 'divide',
      124 => 'print',
      144 => 'num',
      145 => 'scroll',
      186 => ';',
      187 => '=',
      188 => ',',
      189 => '-',
      190 => '.',
      191 => '/',
      192 => '`',
      219 => '[',
      220 => '\\',
      221 => ']',
      222 => '\'',
      224 => 'cmd',
      57_392 => 'ctrl',
      63_289 => 'num'
    }

    # Initializes the event
    #
    # @param event [Event] The native event
    def initialize(event)
      @event = event
    end

    # Runs missing method calls
    #
    # @param name [String] The name of the method
    def method_missing(name)
      `#{@event}[#{name}]`
    end

    # Returns the string represenation of the pressed key
    #
    # @return [String] The pressed key
    def key
      return SPECIAL_KEYS[keyCode] if SPECIAL_KEYS[keyCode]
      `String.fromCharCode(#{keyCode}).toLowerCase()`
    end

    # Stops the immediate propagation of the event
    def stopImmediatePropagation
      `#{@event}.stopImmediatePropagation()`
    end

    # Returns the native dataTransfrer object
    #
    # @return [Object] The object
    def dataTransfer
      Native `#{@event}.dataTransfer`
    end

    # Returns the index of the pressed mouse button
    #
    # @return [Numeric] The index
    def button
      `#{@event}.button`
    end

    # Returns the target of the event
    #
    # @return [DOM::NODE] The target
    def target
      DOM::Element.fromNode `#{@event}.target`
    end

    # Returns the character code of the pressed key
    #
    # @return [Numeric] The code
    def charCode
      `#{@event}.charCode`
    end

    # Returns the key code of the pressed key
    #
    # @return [Numeric] The code
    def keyCode
      `#{@event}.keyCode`
    end

    # Stops the event
    def stop
      preventDefault
      stopPropagation
    end

    # Returns whether the default was prevented or not
    #
    # @return [Boolean] True if it has false if not
    def defaultPrevented?
      `#{@event}.defaultPrevented`
    end

    # Prevents the default action of the event
    def preventDefault
      `#{@event}.preventDefault()`
    end

    # Stops the propagation of the event
    def stopPropagation
      `#{@event}.stopPropagation()`
    end

    # Returns the pageX coordinate of the event
    #
    # @return [Numeric] The coordinate
    def pageX
      `#{@event}.pageX`
    end

    # Returns the pageY coordinate of the event
    #
    # @return [Numeric] The coordinate
    def pageY
      `#{@event}.pageY`
    end

    # Returns the screenX coordinate of the event
    #
    # @return [Numeric] The coordinate
    def screenX
      `#{@event}.screenX`
    end

    # Returns the screenY coordinate of the event
    #
    # @return [Numeric] The coordinate
    def screenY
      `#{@event}.screenY`
    end

    # Returns the clientX coordinate of the event
    #
    # @return [Numeric] The coordinate
    def clientX
      `#{@event}.clientX`
    end

    # Returns the clientY coordinate of the event
    #
    # @return [Numeric] The coordinate
    def clientY
      `#{@event}.clientY`
    end

    # Returns whether the alt key has been pressed
    #
    # @return [Boolan] True if pressed false if not
    def alt?
      `#{@event}.altKey`
    end

    # Returns whether the shift key has been pressed
    #
    # @return [Boolan] True if pressed false if not
    def shift?
      `#{@event}.shiftKey`
    end

    # Returns whether the control key has been pressed
    #
    # @return [Boolan] True if pressed false if not
    def ctrl?
      `#{@event}.ctrlKey`
    end

    # Returns whether the meta (apple) key has been pressed
    #
    # @return [Boolan] True if pressed false if not
    def meta?
      `#{@event}.metaKey`
    end
  end
end
