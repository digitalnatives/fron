module Fron
  module Storage
    # Local Storage wrapper and adapter
    module LocalStorage
      # Gets a value from local storage with the given key
      #
      # @param key [String] The key
      #
      # @return [Object] The value
      def self.get(key)
        value = `window.localStorage.getItem(#{key}) || false`
        value ? JSON.parse(value) : nil
      end

      # Sets a value to local storage with the given key
      #
      # @param key [String] The key
      # @param data [Object] The value
      def self.set(key, data)
        `window.localStorage.setItem(#{key},#{data.to_json})`
      end

      # Removes a value from local storage with the given key
      #
      # @param key [String] The key
      def self.remove(key)
        `window.localStorage.removeItem(#{key})`
      end

      # Returns the all keys present in local storage
      #
      # @return [Array] Array of keys
      def self.keys
        %x{
          ret = []
          for (var key in localStorage){ ret.push(key) }
          return ret
        }
      end

      # Returns all values from local storage
      #
      # @return [Array] Array of values
      def self.all
        keys.map { |key| get key }
      end

      # Clears local storage removeing all values
      def self.clear
        `window.localStorage.clear()`
      end
    end
  end
end
