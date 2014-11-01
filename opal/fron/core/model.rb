module Fron
  # Model
  class Model
    include Eventable
    attr_reader :errors

    class << self
      attr_accessor :fields
      attr_accessor :adapterObject

      # Sets the adapter
      #
      # @param adapter [Class] The adapter
      # @param options [Hash] The options for the adapter
      def adapter(adapter, options = {})
        options.merge! fields: @fields if @fields
        @adapterObject = adapter.new options
      end

      # Defines a filed on the model
      #
      # @param name [String] The name of the field
      def field(name)
        @fields ||= []
        @fields << name

        define_method(name) do
          @data[name]
        end

        define_method(name + '=') do |value|
          @data[name] = value
          trigger 'change'
        end
      end

      # Returns all models that match the data
      #
      # @param data [Hash] The data
      #
      # @yieldparam items [Array] The items
      def all(data = nil)
        @adapterObject.all data do |items|
          break unless block_given?
          yield items.map { |item| new item }
        end
      end

      # Returns one intance of the model that have the given id
      #
      # @param id [String] The id
      #
      # @yieldparam item [Fron::Model] The item
      def find(id)
        user = new
        @adapterObject.get id do |data|
          user.merge data
          yield user
        end
        user
      end
    end

    # Initializes the model with the data
    #
    # @param data [Hash] The data
    def initialize(data = {})
      self.class.field :id
      @data = data
    end

    # Updates the model with the given data
    #
    # @param attributes [Hash] The data
    #
    # @yield When finished
    def update(attributes = {}, &block)
      data = gather.merge! attributes
      self.class.instance_variable_get('@adapterObject').set self, data do |errors, newData|
        @errors = errors
        merge newData
        block.call if block_given?
      end
    end

    # Returns if the model dirty or not
    #
    # @return [Boolean] True if it is false if not
    def dirty?
      !id
    end

    private

    # Clones the instance with extra data
    #
    # @param data [Hash] The data
    #
    # @return [Fron::Model] The clone
    def clone(data = {})
      cl = self.class.new @data.merge data
      cl.instance_variable_set '@errors', errors
      cl
    end

    # Destroys the instance
    #
    # @yield When finished
    def destroy
      self.class.instance_variable_get('@adapterObject').del self do
        yield if block_given?
      end
    end

    # Gathers the data of the model
    #
    # @return [Hash] The data
    def gather
      @data.dup.reject { |key| !self.class.fields.include?(key) }
    end

    # Merges the given data with the model
    #
    # @param data [Hash] The data
    def merge(data)
      data.each_pair do |key, value|
        if self.respond_to?(key + '=')
          send(key + '=', value)
        else
          @data[key] = value
        end
      end
    end
  end
end
