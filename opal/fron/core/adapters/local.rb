require 'json'
require 'securerandom'

module Fron
  module Adapters
    # Local Adapter
    class LocalAdapter
      def initialize(options)
        @options = options
      end

      def all
        yield Fron::Storage::LocalStorage.all
      end

      def get(id)
        yield Fron::Storage::LocalStorage.get id
      end

      def set(model, data)
        id = model.id
        id = SecureRandom.uuid unless id
        data[:id] = id
        errors = validate data
        if errors
          yield errors, {}
        else
          Fron::Storage::LocalStorage.set id, data
          yield nil, data
        end
        data
      end

      def validate(data = {})
        errors = {}
        @options[:fields].reject { |field| field == :id }.map do |field|
          next if data[field] && data[field] != ''
          errors[field] = ["can't be blank"]
        end
        errors.keys.length == 0 ? nil : errors
      end
    end
  end
end
