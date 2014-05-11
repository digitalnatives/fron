module DOM
  module Events
    def on(event, &listener)
    `#{@el}.addEventListener(#{event},function(e){#{ listener.call Event.new(`e`)}})`
    self
    end

    def delegate(event,selector, &listener)
      %x{
        #{@el}.addEventListener(#{event},function(e){
          if(e.target.webkitMatchesSelector(#{selector})){
            #{ listener.call Event.new(`e`)}
          }
        },true)
      }
      self
    end
  end
end
