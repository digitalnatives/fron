require 'json'

module Fron
  # Request
  class Request
    extend Eventable
    extend Forwardable

    # Sets / gets the URL
    #
    # @param value [String] The URL
    # @return [String] The URL
    attr_accessor :url

    # Sets / gets the headers for the request
    #
    # @param value [Hash] The headers
    # @return [Hash] The headers
    attr_accessor :headers

    def_delegators :class, :trigger

    # Initialies the request
    #
    # @param url [String] The url
    # @param headers [Hash] The headers
    def initialize(url, headers = {})
      @url = url
      @headers = headers
      @request = `new XMLHttpRequest()`
      `#{@request}.addEventListener('readystatechange' , function(){#{handle_state_change}})`
      self
    end

    # Runs a request
    #
    # @param method [String] The method
    # @param data [Hash] The data
    #
    # @yieldparam response [Response] The response
    def request(method = 'GET', data = {}, &callback)
      fail 'The request is already running!' if ready_state != 0 && ready_state != 4
      method = method.upcase
      @callback = callback

      args = case method
             when 'UPLOAD'
               ['POST', @url, data.to_form_data]
             when 'GET'
               [method, "#{@url}?#{data.to_query_string}"]
             else
               [method, @url, data.to_json]
             end

      send(*args)

      trigger :loading
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

    # Sends the given data to the given URL
    # with the given method
    #
    # @param method [String] The method
    # @param url [String] The URL
    # @param data [*] The data
    def send(method, url, data = nil)
      `#{@request}.open(#{method}, #{url})`
      `#{@request}.withCredentials = true`
      set_headers
      `#{@request}.send(#{data})`
    end

    # Sets the headers
    def set_headers
      @headers.each_pair do |header, value|
        `#{@request}.setRequestHeader(#{header},#{value})`
      end
    end

    # Returns the ready state of the request
    #
    # @return [Numeric] The ready state
    def ready_state
      `#{@request}.readyState`
    end

    # Handles the hash change
    def handle_state_change
      return unless ready_state == 4
      begin
        response = Response.new `#{@request}.status`, `#{@request}.response`, `#{@request}.getAllResponseHeaders()`
        @callback.call response if @callback
      ensure
        trigger :loaded
      end
    end
  end
end
