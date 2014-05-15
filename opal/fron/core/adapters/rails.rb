module Fron
  module Adapters
    class RailsAdapter

      def initialize(options)
        @options = options
        @request = Request.new
        @request.headers = {'Content-Type' => 'application/json'}
      end

      def all(&block)
        setUrl nil
        @request.get { |response| block.call response.json }
      end

      def get(id,&block)
        setUrl id
        @request.get { |response| block.call response.json }
      end

      def set(id,data,&block)
        setUrl id
        method = id ? 'put' : 'post'
        @request.send(method,transform(data)) do |response|
          block.call case response.status
          when 201, 204
            nil
          when 422
            response.json
          end
        end
      end

      private

      def setUrl(id)
        base = @options[:endpoint] + "/" + @options[:resources]
        base += id ? "/" + id.to_s : ".json"
        @request.url = base
      end

      def transform(data)
        newdata = {}
        newdata[@options[:resource]] = data.dup
        newdata
      end
    end
  end
end
