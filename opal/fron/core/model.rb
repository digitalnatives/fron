module Fron
  class Model
    include Eventable
    attr_reader :errors

    class << self
      attr_accessor :fields
      attr_accessor :adapter

      def adapter(adapter, options = {})
        options.merge! fields: @fields
        @adapter = adapter.new options
      end

      def field(name)
        @fields ||= []
        @fields << name
        define_method(name) do
          @data[name]
        end
        define_method(name+"=") do |value|
          @data[name] = value
          trigger 'change'
        end
      end

      def all(&block)
        @adapter.all do |items|
          block.call items.map{ |item| self.new item }
        end
      end

      def find(id, &block)
        user = self.new
        @adapter.get id do |data|
          user.merge data
          block.call user
        end
        user
      end
    end

    def initialize(data = {})
      @data  = data
    end

    def update(attributes, &block)
      data = @data.dup.merge! attributes
      self.class.instance_variable_get("@adapter").set id, data do |errors|
        @errors = errors
        merge data
        block.call if block_given?
      end
    end

    def dirty?
      !self.id
    end

    private

    def merge(data)
      data.each_pair do |key,value|
        self.send(key+"=", value) if self.respond_to?(key+"=")
      end
    end
  end
end
