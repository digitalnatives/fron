module Fron
  module Adapters
    # Rails Adapter
    class RailsAdapter
      def initialize(options)
        @options = options
        @request = Request.new
        @request.headers = { 'Content-Type' => 'application/json' }
      end

      def del(model)
        setUrl model
        @request.request 'DELETE', transform({})  do
          yield
        end
      end

      def all(data = nil)
        setUrl nil
        @request.get(data) { |response| yield response.json }
      end

      def get(id)
        setUrl id
        @request.get { |response| yield response.json }
      end

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
