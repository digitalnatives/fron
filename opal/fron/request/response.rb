module Fron
  # Response
  class Response
    attr_reader :body, :headers, :status

    # Initializes the response
    #
    # @param status [Numeric] The status
    # @param body [String] The response body
    # @param headers [Hash] The headers
    #
    # @return [type] [description]
    def initialize(status, body, headers)
      @body    = body
      @status  = status
      @headers = {}

      headers.strip.split(/\n/).each do |item|
        match = item.split(/:/)
        @headers[match[0]] = match[1].strip
      end
    end

    # Returns the content type of the response
    #
    # @return [String] The content type
    def content_type
      @headers['Content-Type']
    end

    # Returns whether the request was successfull
    #
    # @return [Boolean] True if it was false if not
    def ok?
      @status == 200
    end

    # Returns the response body as json
    #
    # @return [Hash] The body
    def json
      JSON.parse @body
    end

    # Returns the response body as DOM::Fragment
    #
    # @return [DOM::Fragment] The body
    def dom
      div = DOM::Element.new 'div'
      div.html = @body
      fragment = DOM::Fragment.new
      fragment << div
      fragment
    end
  end
end
