module Fron
  module Adapters
    class RailsAdapter

      def initialize(options)
        @options = options
        @request = Request.new
        @request.headers = {'Content-Type' => 'application/json'}
      end

      def del(model,&block)
        setUrl model
        @request.request 'DELETE', transform({})  do
          block.call
        end
      end

      def all(data = nil, &block)
        setUrl nil
        @request.get(data) { |response| block.call response.json }
      end

      def get(id,&block)
        setUrl id
        @request.get { |response| block.call response.json }
      end

      def set(model,data,&block)
        setUrl model
        method = model.id ? 'put' : 'post'
        @request.send(method,transform(data)) do |response|
          error = case response.status
          when 201, 204
            nil
          when 422
            response.json
          end
          block.call error, response.json
        end
      end

      private

      def setUrl(model)
        id = model.is_a?(Fron::Model) ? model.id : model
        endpoint = if @options[:endpoint].is_a? Proc
            model.instance_eval &@options[:endpoint]
          else
            @options[:endpoint]
          end
        base = endpoint + "/" + @options[:resources]
        base += id ? "/" + id.to_s : ".json"
        @request.url = base
      end

      def transform(data)
        newdata = {}
        meta = DOM::Document.head.find("meta[name=csrf-token]")
        newdata[:authenticity_token] = meta['content'] if meta
        newdata[@options[:resource]] = data.dup
        newdata
      end
    end
  end
end
