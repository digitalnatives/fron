module Fron
  module Behaviors
    # Style
    module Style
      # Runs for included classes
      #
      # @param base [Class] The class
      def self.included(base)
        base.register self, [:style, :keyframes]
        base.meta_def :stylesheet do |url|
          Sheet.stylesheet url
        end
      end

      def self.keyframes(item)
        Sheet.add_animation item[:args].first, item[:args][1]
      end

      # Defines styles for the component
      #
      # @param item [Array] The styles
      def self.style(item)
        Sheet.add_rule tag, item[:args].first, item[:id]
      end
    end
  end
end
