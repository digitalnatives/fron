module Fron
  class Component < DOM::Element
    attr_reader :model

    class << self
      attr_reader :events
      attr_reader :tagname
      attr_reader :components
      attr_reader :delegates

      def inherited(subclass)
        [:components,:events,:delegates].each do |type|
          if (var = instance_variable_get("@#{type}"))
            inst_var = subclass.instance_variable_get('@#{type}')
            subclass.instance_variable_set("@#{type}", []) unless inst_var
            subclass.send(type).concat var
          end
        end
      end

      def tag(tag)
        @tagname = tag
      end

      def on(*args)
        @events ||= []
        @events << args
      end

      def component(*args,&block)
        attr_reader args[0]
        @components ||= []
        @components << ( args << block )
      end

      def delegate(*args)
        @delegates ||= []
        @delegates << args
      end
    end

    def initialize(*args)
      case args.length
      when 1
        @model = args[0]
      when 2
        tag, @model = args
      when 3
        tag, options, @model = args
      end

      super tag || self.class.tagname || self.class.name.split("::").last

      applyEvents
      createComponents
      applyDelegates

      if options
        options.each do |method,value|
          self.send(method+"=",value) if self.respond_to?(method+"=")
        end
      end

      return if !respond_to?(:render) || !@model
      @model.on 'change' do render end
      render
    end

    def component(name,comp,options,&block)
      c = comp.is_a?(Class) ? comp.new(nil,options,@model) : Component.new(comp, options, @model)
      c.instance_eval(&block) if block
      self << c
      self.instance_variable_set "@#{name}", c
    end

    private

    def createComponents
      return unless self.class.components
      self.class.components.each do |args|
        arguments = args.dup
        block = arguments.last.is_a?(Proc) ? arguments.pop : nil
        component *arguments, &block
      end
    end

    def applyDelegates
      return unless self.class.delegates
      self.class.delegates.each do |args|
        method, target = args
        self.class.define_method(method) do
          instance_variable_get("@#{target}").send(method)
        end

        self.class.define_method(method+"=") do |value|
          instance_variable_get("@#{target}").send(method+"=",value)
        end
      end
    end

    def applyEvents
      return unless self.class.events
      self.class.events.each do |args|
        if args.length == 3
          delegate(args[0], args[1]) { |e| self.method(args[2]).call e }
        else
          on(args[0]) { |e| self.method(args[1]).call e }
        end
      end
    end
  end
end
