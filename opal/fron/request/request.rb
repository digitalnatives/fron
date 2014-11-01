require 'json'

module Fron
  # Request
  class Request
    attr_accessor :url, :headers

    # Initialies the request
    #
    # @param url [String] The url
    # @param headers [Hash] The headers
    def initialize(url, headers = {})
      @url = url
      @headers = headers
      @request = `new XMLHttpRequest()`
      `#{@request}.addEventListener('readystatechange' , function(){#{handleStateChange}})`
      self
    end

    # Runs a request
    #
    # @param method [String] The method
    # @param data [Hash] The data
    #
    # @yieldparam response [Response] The response
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

    # Runs a GET request
    #
    # @param data [Hash] The data
    #
    # @yieldparam response [Response] The response
    def get(data, &callback)
      request 'GET', data, &callback
    end

    # Runs a POST request
    #
    # @param data [Hash] The data
    #
    # @yieldparam response [Response] The response
    def post(data, &callback)
      request 'POST', data, &callback
    end

    # Runs a PUT request
    #
    # @param data [Hash] The data
    #
    # @yieldparam response [Response] The response
    def put(data, &callback)
      request 'PUT', data, &callback
    end

    private

    # Sets the headers
    def setHeaders
      @headers.each_pair do |header, value|
        `#{@request}.setRequestHeader(#{header},#{value})`
      end
    end

    # Returns the ready state of the request
    #
    # @return [Numeric] The ready state
    def readyState
      `#{@request}.readyState`
    end

    # Handles the hash change
    def handleStateChange
      return unless readyState == 4
      response = Response.new `#{@request}.status`, `#{@request}.response`, `#{@request}.getAllResponseHeaders()`
      @callback.call response if @callback
    end
  end
end
