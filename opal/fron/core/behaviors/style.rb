module Fron
  module Behaviors
    # Style
    module Style
      # Sheet
      module Sheet
        class << self
          # Creates style tag to store the styles
          #
          # @return [DOM::Element] The style tag
          def style
            return @style if @style
            @style = DOM::Element.new 'style'
            @style >> DOM::Document.head
            @style
          end

          # Adds a rule for the given tag
          # with the given data
          #
          # @param tag [String] The selector for the tag
          # @param data [Hash] The styles
          def add_rule(tag, data)
            @rules ||= {}
            return if @rules[tag]
            text = data.map do |key, value|
              if value.is_a? Hash
                if key =~ /&/
                  add_rule key.gsub(/&/, tag), value
                else
                  add_rule "#{tag} #{key}", value
                end
                next
              else
                key = key.gsub(/(.)([A-Z])/, '\1-\2').downcase
                value = value.call if value.is_a? Proc
                "#{key}: #{value};"
              end
            end.join(' ')
            @rules[tag] = text
            render
          end

          # Renders the styles
          def render
            style.text = @rules.map { |tag, text| "#{tag} { #{text} }" }.join("\n")
          end

          # Defines a stylesheet link tag
          #
          # @param url [String] The URL for the stylesheet
          def stylesheet(url)
            @stylesheets ||= {}
            return if @stylesheets[url]
            @stylesheets[url] = true
            sheet = DOM::Element.new "link[rel=stylesheet][href=#{url}][type=text/css]"
            sheet >> DOM::Document.head
          end
        end
      end

      # Runs for included classes
      #
      # @param base [Class] The class
      def self.included(base)
        base.register self, [:style]
        base.meta_def :stylesheet do |url|
          Sheet.stylesheet url
        end
      end

      # Defines styles for the component
      #
      # @param item [Array] The styles
      def self.style(item)
        data = item[0].to_h
        Sheet.add_rule tag, data
      end
    end
  end
end
