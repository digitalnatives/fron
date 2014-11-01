module Fron
  module Adapters
    # Rails Adapter
    class RailsAdapter
      # Initializes the adapter with options
      #
      # @param options [Hash] The options
      def initialize(options)
        @options = options
        @request = Request.new
        @request.headers = { 'Content-Type' => 'application/json' }
      end

      # Deletes the given model
      #
      # @param model [Fron::Model] The model
      def del(model)
        setUrl model
        @request.request 'DELETE', transform({})  do
          yield
        end
      end

      # Returns all values
      #
      # @yieldparam values [Array] The values
      def all(data = nil)
        setUrl nil
        @request.get(data) { |response| yield response.json }
      end

      # Gets the data with the given id
      #
      # @param id [String] The id
      #
      # @yieldparam data [Hash] The data
      def get(id)
        setUrl id
        @request.get { |response| yield response.json }
      end

      # Sets the given data for the given model
      #
      # @param model [Fron::Model] The model
      # @param data [Hash] The data
      #
      # @yieldparam error [Hash] The errors or nil
      # @yieldparam data [Hash] The data
      def set(model, data)
        setUrl model
        method = model.id ? 'put' : 'post'
        @request.send(method, transform(data)) do |response|
          error = case response.status
                  when 201, 204
                    nil
                  when 422
                    response.json
                  end
          yield error, response.json
        end
      end

      private

      # Sets the request url based on the model
      #
      # @param model [Fron::Model] The model
      def setUrl(model)
        id = model.is_a?(Fron::Model) ? model.id : model
        endpoint = @options[:endpoint]
        endpoint = if endpoint.is_a? Proc
                     model.instance_eval(&endpoint)
                   else
                     endpoint
                   end
        base = endpoint + '/' + @options[:resources]
        base += id ? '/' + id.to_s : '.json'
        @request.url = base
      end

      # Transforms the data to match Rails conventions
      #
      # @param data [Hash] The old data
      #
      # @return [Hash] The transformed data
      def transform(data)
        newdata = {}
        meta = DOM::Document.head.find('meta[name=csrf-token]')
        newdata[:authenticity_token] = meta['content'] if meta
        newdata[@options[:resource]] = data.dup
        newdata
      end
    end
  end
end
