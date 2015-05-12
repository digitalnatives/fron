module Fron
  # Sheet
  module Sheet
    class << self
      # Helpers context class
      class Helpers
      end

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
      #
      # BUG: https://github.com/opal/opal/issues/844
      #      use each_with_object({}) after it's resolved
      def add_rule(tag, data, id)
        @rules ||= {}
        @rules[tag] ||= {}
        return if @rules[tag][id]
        style = {}
        data.each do |key, value|
          if value.is_a? Hash
            value['_rule_id'] ||= SecureRandom.uuid
            if key =~ /&/
              add_rule key.gsub(/&/, tag), value, value['_rule_id']
            else
              key.split(',').each do |part|
                add_rule "#{tag.strip} #{part.strip}", value, value['_rule_id']
              end
            end
          else
            style[key.gsub(/(.)([A-Z])/, '\1-\2').downcase] = value
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
        data.values.reduce(&:merge).to_h.map { |key, value|
          val = value.is_a?(Proc) ? helper.instance_eval(&value) : value
          "#{key}: #{val};"
        }.join('')
      end

      # Returns the helper for the proc rendering.
      #
      # @return [Helper] The helper
      def helper
        @helper ||= Helpers.new
      end

      def helpers(&block)
        Helpers.class_eval(&block)
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
end
