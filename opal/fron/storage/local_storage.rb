module Fron
  module Storage
    # Local Storage wrapper and adapter
    module LocalStorage
      extend Store

      def self.store
        `window.localStorage`
      end
    end
  end
end
