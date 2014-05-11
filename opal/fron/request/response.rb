module Fron
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

    def content_type
      @headers['Content-Type']
    end

    def ok?
      @status == 200
    end

    def json
      JSON.parse @body
    end

    def dom
      d = DOM::Element.new 'div'
      d.html = @body
      f = DOM::Fragment.new()
      f << d
      f
    end
  end
end
