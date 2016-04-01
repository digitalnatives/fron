module Fron
  module Storage
    # Local Storage wrapper and adapter
    module SessionStorage
      extend Store

      def self.store
        `window.sessionStorage`
      end
    end
  end
end
