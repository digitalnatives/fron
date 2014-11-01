require 'json'

module Fron
  # Request
  class Request
    attr_accessor :url, :headers

    def initialize(url, headers = {})
      @url = url
      @headers = headers
      @request = `new XMLHttpRequest()`
      `#{@request}.addEventListener('readystatechange' , function(){#{handleStateChange}})`
      self
    end

    def request(method = 'GET', data = nil, &callback)
      if readyState == 0 || readyState == 4
        @callback = callback
        if method.upcase == 'GET' && data
          `#{@request}.open(#{method},#{@url + '?' + data.toQueryString})`
          setHeaders
          `#{@request}.send()`
        else
          `#{@request}.open(#{method},#{@url})`
          setHeaders
          `#{@request}.send(#{data.to_json if data})`
        end
      else
        fail 'The request is already running!'
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

    private

    def setHeaders
      @headers.each_pair do |header, value|
        `#{@request}.setRequestHeader(#{header},#{value})`
      end
    end

    def readyState
      `#{@request}.readyState`
    end

    def handleStateChange
      return unless readyState == 4
      response = Response.new `#{@request}.status`, `#{@request}.response`, `#{@request}.getAllResponseHeaders()`
      @callback.call response if @callback
    end
  end
end
