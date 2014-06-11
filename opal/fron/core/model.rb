module Fron
  class Model
    include Eventable
    attr_reader :errors

    class << self
      attr_accessor :fields
      attr_accessor :adapterObject

      def adapter(adapter, options = {})
        options.merge! fields: @fields if @fields
        @adapterObject = adapter.new options
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

      def all(data = nil, &block)
        @adapterObject.all data do |items|
          break unless block_given?
          block.call items.map{ |item| self.new item }
        end
      end

      def find(id, &block)
        user = self.new
        @adapterObject.get id do |data|
          user.merge data
          block.call user
        end
        user
      end
    end

    def initialize(data = {})
      self.class.field :id
      @data = data
    end

    def update(attributes = {}, &block)
      data = gather.merge! attributes
      self.class.instance_variable_get("@adapterObject").set self, data do |errors,data|
        @errors = errors
        merge data
        block.call if block_given?
      end
    end

    def dirty?
      !self.id
    end

    private

    def clone(data = {})
      cl = self.class.new @data.merge data
      cl.instance_variable_set "@errors", self.errors
      cl
    end

    def destroy(&block)
      self.class.instance_variable_get("@adapterObject").del self do
        block.call if block_given?
      end
    end

    def gather
      @data.dup.reject{|key| !self.class.fields.include?(key)}
    end

    def merge(data)
      data.each_pair do |key,value|
        if self.respond_to?(key+"=")
          self.send(key+"=", value)
        else
          @data[key] = value
        end
      end
    end
  end
end
