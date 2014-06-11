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

      def set(model, data, &block)
        id = model.id
        id = SecureRandom.uuid unless id
        data[:id] = id
        unless (errors = validate data)
          Fron::Storage::LocalStorage.set id, data
          block.call nil, data
        else
          block.call errors, {}
        end
        data
      end

      def validate(data = {})
        errors = {}
        @options[:fields].reject{|field| field == :id}.map do |field|
          next if data[field] && data[field] != ""
          errors[field] = ["can't be blank"]
          valid = false
        end
        errors.keys.length == 0 ? nil : errors
      end
    end
  end
end
