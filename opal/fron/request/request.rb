require 'json'

module Fron
  class Request
    attr_accessor :url, :headers

    def initialize(url, headers = {})
      @url = url
      @request = `new XMLHttpRequest()`
      `#{@request}.addEventListener('readystatechange' , function(){#{handle_state_change}})`
      self
    end

    def handle_state_change
      if ready_state == 4
        response = Response.new `#{@request}.status`, `#{@request}.response`, `#{@request}.getAllResponseHeaders()`
        @callback.call response
      end
    end

    def ready_state
      `#{@request}.readyState`
    end

    def request( method = 'GET',data = nil, &callback)
      if ready_state == 0 or ready_state == 4
        if method.upcase == "GET" && data
          `#{@request}.open(#{method},#{@url+"?"+data.to_query_string})`
        else
          `#{@request}.open(#{method},#{@url})`
        end
        @callback = callback
        `#{@request}.send(#{data.to_form_data if data})`
      else
        raise "The request is already running!"
      end
    end

    def get(data, &callback)
      request 'GET', data, &callback
    end

    def post(data, &callback)
      request 'POST', data, &callback
    end

    def put(data, &callback)
      request 'PUT', data, &callback
    end
  end
end
