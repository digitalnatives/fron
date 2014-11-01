module Fron
  # Component
  class Component < DOM::Element
    attr_reader :model

    class << self
      attr_reader :events
      attr_reader :tagname
      attr_reader :components
      attr_reader :delegates

      # Handles inherited componets passing self
      # components, events, etc...
      #
      # @param subclass [Class] The subclass
      def inherited(subclass)
        [:components, :events, :delegates].each do |type|
          next unless (var = instance_variable_get("@#{type}"))
          instVar = subclass.instance_variable_get("@#{type}")
          subclass.instance_variable_set("@#{type}", []) unless instVar
          subclass.send(type).concat var
        end
      end

      # Sets the tag name of the component
      #
      # @param tag [String] The tag name
      def tag(tag)
        @tagname = tag
      end

      # Adds events to the event array
      #
      # @param args [Array] The arguments
      def on(*args)
        @events ||= []
        @events << args
      end

      # Adds components to the component array
      #
      # @param args [Array] The arguments
      # @param block [Proc] The block
      def component(*args, &block)
        attr_reader args[0]
        @components ||= []
        @components << (args << block)
      end

      # Adds events to the delegates array
      #
      # @param args [Array] The arguments
      def delegate(*args)
        @delegates ||= []
        @delegates << args
      end
    end

    # Initalizs the component
    #
    # @param args [Array] The arguments
    def initialize(*args)
      case args.length
      when 1
        @model = args[0]
      when 2
        tag, @model = args
      when 3
        tag, options, @model = args
      end

      super tag || self.class.tagname || self.class.name.split('::').last

      applyEvents
      createComponents
      applyDelegates

      if options
        options.each do |method, value|
          send(method + '=', value) if self.respond_to?(method + '=')
        end
      end

      return if !respond_to?(:render) || !@model
      @model.on 'change' do render end
      render
    end

    # Creates a child component
    #
    # @param name [String] The name of the component
    # @param comp [Class] The component
    # @param options [Hash] The options
    # @param block [Proc] The block to eval on the new component
    def component(name, comp, options, &block)
      component = comp.is_a?(Class) ? comp.new(nil, options, @model) : Component.new(comp, options, @model)
      component.instance_eval(&block) if block
      self << component
      instance_variable_set "@#{name}", component
    end

    private

    # Creates components
    def createComponents
      return unless self.class.components
      self.class.components.each do |args|
        arguments = args.dup
        block = arguments.last.is_a?(Proc) ? arguments.pop : nil
        component(*arguments, &block)
      end
    end

    # Applies delegated events
    def applyDelegates
      klass = self.class
      return unless klass.delegates
      klass.delegates.each do |args|
        method, target = args
        klass.define_method(method) do
          instance_variable_get("@#{target}").send(method)
        end

        klass.define_method(method + '=') do |value|
          instance_variable_get("@#{target}").send(method + '=', value)
        end
      end
    end

    # Applies events
    def applyEvents
      return unless self.class.events
      self.class.events.each do |args|
        if args.length == 3
          delegate(args[0], args[1]) { |event| method(args[2]).call event }
        else
          on(args[0]) { |event| method(args[1]).call event }
        end
      end
    end
  end
end
