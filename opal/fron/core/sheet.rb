module Fron
  # Module for handling component styles
  module Sheet
    class << self
      attr_accessor :additional_styles

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
      def add_rule(tag, data, id)
        @rules ||= {}
        @rules[tag] ||= {}
        @rules[tag][id] ||= data.each_with_object({}) do |(key, value), style|
          if value.is_a? Hash
            handle_rule_raw_hash tag, key, value
          else
            style[key] = value
          end
        end
      end

      def handle_rule_raw_hash(tag, key, value)
        value['_rule_id'] ||= SecureRandom.uuid
        id = value['_rule_id']
        if key =~ /&/
          add_rule key.gsub(/&/, tag), value, id
        else
          key.split(',').each do |part|
            add_rule "#{tag.strip} #{part.strip}", value, id
          end
        end
      end

      # Renders the styles
      def render
        [render_stylesheets,
         additional_styles.to_s,
         render_rules].join("\n")
      end

      def render_rules
        @rules.map { |tag, data|
          body = tag.start_with?('@') ? render_at_block(data) : render_rule(data)
          "#{tag} { #{body} }"
        }.join("\n")
      end

      def render_stylesheets
        @stylesheets
          .to_h
          .keys
          .map { |url| "@import(#{url});" }
          .join("\n")
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
          render_property prop, value
        end.join('')
      end

      def render_property(prop, value)
        return if prop == '_rule_id'
        val = value.is_a?(Proc) ? helper.instance_eval(&value) : value
        prop = prop.gsub(/(.)([A-Z])/, '\1-\2').downcase
        "#{prop}: #{val};"
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
