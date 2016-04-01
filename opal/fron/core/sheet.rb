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
            style[key] = value
          end
        end
        @rules[tag][id] = style
      end

      # Renders the styles
      def render
        imports = @stylesheets.keys
                              .map { |url| "@import(#{url});" }
                              .join("\n")

        rules = @rules.map { |tag, data|
          body = tag.start_with?('@') ? render_at_block(data) : render_rule(data)
          "#{tag} { #{body} }"
        }.join("\n")

        [imports, rules].join("\n")
      end

      # Returns the helper for the proc rendering.
      #
      # @return [Helper] The helper
      def helper
        @helper ||= Helpers.new
      end

      # Elavulates the given block in the helper scope.
      #
      # @param block [Proc] The block
      def helpers(&block)
        Helpers.class_eval(&block)
      end

      # Renders an at block
      #
      # @param data [Hash] The data
      def render_at_block(data)
        data.map { |key, block| "#{key} { #{render_block(block)} }" }.join('')
      end

      # Renders a rule with multiple "versions"
      #
      # @param data [Hash] The data
      def render_rule(data)
        render_block data.values.reduce(&:merge).to_h
      end

      # Renders an block of single key, values
      #
      # @param data [Hash] The data
      def render_block(block)
        block.map do |prop, value|
          next if prop == '_rule_id'
          val = value.is_a?(Proc) ? helper.instance_eval(&value) : value
          prop = prop.gsub(/(.)([A-Z])/, '\1-\2').downcase
          "#{prop}: #{val};"
        end.join('')
      end

      def render_style_tag
        style.text = render
      end

      # Adds an animation with the given data
      #
      # @param name [String] The name
      # @param data [Hash] The data
      def add_animation(name, data)
        @rules ||= {}
        return if @rules["@keyframes #{name}"]
        @rules["@keyframes #{name}"] ||= data
      end

      # Defines a stylesheet link tag
      #
      # @param url [String] The URL for the stylesheet
      def stylesheet(url)
        @stylesheets ||= {}
        return if @stylesheets[url]
        @stylesheets[url] = true
      end
    end
  end
end
