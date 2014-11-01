require 'json'
require 'securerandom'

module Fron
  module Adapters
    # Local Adapter
    class LocalAdapter
      # Initializes the adapter with options
      #
      # @param options [Hash] The options
      def initialize(options)
        @options = options
      end

      # Returns all values
      #
      # @return [Array] The values
      def all
        yield Fron::Storage::LocalStorage.all
      end

      # Gets the data with the given id
      #
      # @param id [String] The id
      #
      # @return [Hash] The data
      def get(id)
        yield Fron::Storage::LocalStorage.get id
      end

      # Sets the given data for the given model
      #
      # @param model [Fron::Model] The model
      # @param data [Hash] The data
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

      # Validates the given data
      #
      # @param data [Hash] The data
      #
      # @return [Array] The errors after the validation or nil
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
