module DOM
  class Event

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
      57392 => 'ctrl',
      63289 => 'num'
    }

    def initialize(e,targetClass)
      @e = e
      @targetClass = targetClass
    end

    def key
      return SPECIAL_KEYS[keyCode] if SPECIAL_KEYS[keyCode]
      `String.fromCharCode(#{keyCode}).toLowerCase()`
    end

    def stopImmediatePropagation
      `#{@e}.stopImmediatePropagation()`
    end

    def dataTransfer
      Native `#{@e}.dataTransfer`
    end

    def button
      `#{@e}.button`
    end

    def target
      @targetClass.new `#{@e}.target`
    end

    def charCode
      `#{@e}.charCode`
    end

    def keyCode
      `#{@e}.keyCode`
    end

    def stop
      preventDefault
      stopPropagation
    end

    def preventDefault
      `#{@e}.preventDefault()`
    end

    def stopPropagation
      `#{@e}.stopPropagation()`
    end

    def pageX
      `#{@e}.pageX`
    end

    def pageY
      `#{@e}.pageY`
    end

    def screenX
      `#{@e}.screenX`
    end

    def screenY
      `#{@e}.screenY`
    end

    def clientX
      `#{@e}.clientX`
    end

    def clientY
      `#{@e}.clientY`
    end

    def alt?
      `#{@e}.altKey`
    end

    def shift?
      `#{@e}.shiftKey`
    end

    def ctrl?
      `#{@e}.ctrlKey`
    end

    def meta?
      `#{@e}.metaKey`
    end
  end
end
