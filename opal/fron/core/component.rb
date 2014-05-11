module Fron
  class Component < DOM::Element
    attr_reader :model

    class << self
      attr_accessor :events
      attr_accessor :tagname
      attr_accessor :components

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

      def delegate(method,target)
        define_method(method) do
          instance_variable_get("@#{target}").send(method)
        end

        define_method(method+"=") do |value|
          instance_variable_get("@#{target}").send(method+"=",value)
        end
      end
    end

    def initialize(*args)
      case args.length
      when 1
        @model = args[0]
      when 2
        tag, @model = args
      end

      super tag || self.class.tagname || self.class.name.split("::").last

      applyEvents
      createComponents

      return if !respond_to?(:render) || !@model
      @model.on 'change' do render end
      render
    end

    def component(name,comp,&block)
      c = comp.is_a?(Class) ? comp.new(@model) : Component.new(comp, @model)
      c.instance_eval(&block) if block
      self << c
      self.instance_variable_set "@#{name}", c
    end

    private

    def createComponents
      return unless self.class.components
      self.class.components.each do |args|
        component args[0], args[1], &args[2]
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
