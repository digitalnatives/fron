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
          def add_rule(tag, data, id)
            @rules ||= {}
            @rules[tag] ||= {}
            return if @rules[tag][id]
            style = data.each_with_object({}) do |(key, value), memo|
              if value.is_a? Hash
                if key =~ /&/
                  add_rule key.gsub(/&/, tag), value, id
                else
                  new_value = value.dup
                  key.split(',').each do |part|
                    add_rule "#{tag.strip} #{part.strip}", new_value, id
                  end
                end
                next
              else
                memo[key.gsub(/(.)([A-Z])/, '\1-\2').downcase] = value.is_a?(Proc) ? value.call : value
              end
            end
            @rules[tag][id] = style
            render_proc.call
          end

          def render_proc
            @render_proc ||= RenderProc.new method(:render), true, 'Rendered styles'
          end

          # Renders the styles
          def render
            style.text = @rules.map { |tag, data| "#{tag} { #{render_rule(data)} }" }.join("\n")
          end

          def render_rule(data)
            data.values.reduce(&:merge!).to_h.map { |key, value| "#{key}: #{value};" }.join('')
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
        Sheet.add_rule tag, item[:args].first, item[:id]
      end
    end
  end
end
