module Fron
  # Response
  class Response
    attr_reader :body, :headers, :status

    def initialize(status, body, headers)
      @body    = body
      @status  = status
      @headers = {}

      headers.strip.split(/\n/).each do |item|
        match = item.split(/:/)
        @headers[match[0]] = match[1].strip
      end
    end

    def contentType
      @headers['Content-Type']
    end

    def ok?
      @status == 200
    end

    def json
      JSON.parse @body
    end

    def dom
      div = DOM::Element.new 'div'
      div.html = @body
      fragment = DOM::Fragment.new
      fragment << div
      fragment
    end
  end
end
