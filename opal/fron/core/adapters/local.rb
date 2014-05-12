require 'json'
require 'securerandom'

module Fron
  module Adapters
    class LocalAdapter
      def initialize(options)
        @options = options
      end

      def all(&block)
        block.call Fron::Storage::LocalStorage.all
      end

      def get(id, &block)
        block.call Fron::Storage::LocalStorage.get id
      end

      def set(id, data, &block)
        id = SecureRandom.uuid unless id
        data[:id] = id
        unless (errors = validate data)
          Fron::Storage::LocalStorage.set id, data
          block.call nil
        else
          block.call errors
        end
      end

      def validate(data)
        errors = {}
        @options[:fields].map do |field|
          next unless data[field] == ""
          errors[field] = ["can't be blank"]
          valid = false
        end
        errors.keys.length == 0 ? nil : errors
      end
    end
  end
end
