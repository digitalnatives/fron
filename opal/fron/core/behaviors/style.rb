module Fron
  module Behaviors
    # Behavior for hanlding styles on components.
    module Style
      # Runs for included classes
      #
      # @param base [Class] The class
      def self.included(base)
        base.meta_def :ensure_styles! do
          styles.each do |(style, id)|
            Sheet.add_rule tagname, style, id
          end
        end

        base.meta_def :style do |item|
          styles << [item, SecureRandom.uuid]
          ensure_styles!
        end

        base.meta_def :keyframes do |name, data|
          Sheet.add_animation name, data
        end

        base.meta_def :stylesheet do |url|
          Sheet.stylesheet url
        end
      end
    end
  end
end
