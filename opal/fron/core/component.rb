require 'fron/core/behaviors/components'
require 'fron/core/behaviors/events'
require 'fron/core/behaviors/routes'

module Fron
  # Component
  class Component < DOM::Element
    class << self
      # @return [String] The tagname of the component
      attr_reader :tagname

      # @return [Array] The registry of behaviors
      attr_reader :registry

      # Creates a new class with the specific tag
      #
      # @param tag [String] The tag
      #
      # @return [Fron::Component] The new component
      def create(tag)
        klass = Class.new self
        klass.tag tag
        klass
      end

      # Register a behavior
      #
      # @param behavior [Module] The behavior
      # @param methods [Array] The methods to register
      def register(behavior, methods)
        @registry ||= []

        methods.each do |name|
          meta_def name do |*args, &block|
            args.unshift behavior.method(name)
            args << block if block_given?
            @registry << args
          end
        end
      end

      # Handles inheritance
      #
      # @param subclass [Class] The subclass
      def inherited(subclass)
        # Copy behaviours
        subclass.instance_variable_set '@registry', @registry.dup
      end

      # Sets the tag name of the component
      #
      # @param tag [String] The tag name
      def tag(tag)
        @tagname = tag
      end
    end

    include Behaviors::Components
    include Behaviors::Events

    # Initalizs the component
    #
    # @param tag [String] The tagname
    def initialize(tag = nil)
      klass = self.class

      super tag || klass.tagname || klass.name.split('::').last

      klass.registry.each do |item|
        instance_exec item[1..-1], &item.first
      end
    end
  end
end
