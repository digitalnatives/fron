module Fron
  module Storage
    # Abstract wrapper and adapter for the Storage API
    module Store
      # Gets a value from the store with the given key
      #
      # @param key [String] The key
      #
      # @return [Object] The value
      def get(key)
        value = `#{store}.getItem(#{key}) || false`
        value ? JSON.parse(value) : nil
      end

      # Sets a value to the store with the given key
      #
      # @param key [String] The key
      # @param data [Object] The value
      def set(key, data)
        `#{store}.setItem(#{key},#{data.to_json})`
      end

      # Removes a value from the store with the given key
      #
      # @param key [String] The key
      def remove(key)
        `#{store}.removeItem(#{key})`
      end

      # Returns the all keys present in store
      #
      # @return [Array] Array of keys
      def keys
        %x{
          ret = []
          for (var key in #{store}){ ret.push(key) }
          return ret
        }
      end

      # Returns all values from the store
      #
      # @return [Array] Array of values
      def all
        keys.map { |key| get key }
      end

      # Clears the store, removeing all values
      def clear
        `#{store}.clear()`
      end
    end
  end
end
