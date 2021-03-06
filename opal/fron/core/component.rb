require 'fron/core/behaviors/components'
require 'fron/core/behaviors/events'
require 'fron/core/behaviors/routes'
require 'fron/core/behaviors/style'
require 'securerandom'

module Fron
  # Base class for components.
  class Component < DOM::Element
    class << self
      # @return [String] The tagname of the component
      attr_reader :tagname

      # @return [Array] The registry of behaviors
      attr_reader :registry

      # @return [Array] The styles for this component
      attr_reader :styles

      attr_reader :defaults

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
        @styles ||= []

        methods.each do |name|
          meta_def name do |*args, &block|
            @registry << { method: behavior.method(name), args: args, block: block, id: SecureRandom.uuid }
          end
        end
      end

      def defaults(data = nil)
        return @defaults unless data
        @defaults ||= {}
        @defaults.merge! data
      end

      # Handles inheritance
      #
      # @param subclass [Class] The subclass
      def inherited(subclass)
        # Copy behaviours
        subclass.instance_variable_set '@registry', @registry.dup
        subclass.instance_variable_set '@styles', @styles.dup
        subclass.instance_variable_set '@defaults', (@defaults || {}).dup
      end

      # Sets the tag name of the component
      #
      # @param tag [String] The tag name
      def tag(tag)
        @tagname = tag
      end

      def tagname
        @tagname || name.split('::').join('-').downcase
      end
    end

    include Behaviors::Components
    include Behaviors::Events
    include Behaviors::Style

    TAGNAME_REGEXP = /^\w([\w\d-]+)*$/

    # Initalizs the component
    #
    # @param tag [String] The tagname
    def initialize(tagname = nil)
      klass = self.class

      tag = tagname || klass.tagname

      raise "Invalid tag '#{tag}' for #{self}!" unless tag =~ TAGNAME_REGEXP

      super tag

      klass.registry.each do |item|
        instance_exec item, &item[:method].unbind.bind(self)
      end

      klass.defaults.to_h.each do |key, value|
        if respond_to?("#{key}=")
          send "#{key}=", value
        else
          self[key] = value
        end
      end
    end
  end
end
