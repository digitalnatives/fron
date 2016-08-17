require 'fron/js/virtual_dom'
require 'promise'

module Fron
  module VDomBuilder
    attr_accessor :bound

    def node(tag, params = {}, &block)
      raise 'Invalid tag' unless tag || !tag.is_a?(String)
      nodes = @nodes || []
      clear
      instance_eval &block
      children = @nodes
      @nodes = nodes
      node = `virtualDom.h(#{tag}, #{process_params(params).to_n}, #{children.to_n})`
      @nodes << node
      node
    end

    def process_params(params)
      return {} unless params.is_a?(Hash)
      params.dup.each do |k, v|
        case k
        when 'class'
          params['className'] = params.delete('class')
        when 'data'
          params['dataset'] = params.delete('data')
        when 'default'
          params['defaultValue'] = params.delete('default')
        else
          params[k] = process_value(v)
        end
      end
      params
    end

    def process_value(v)
      if v.is_a?(Method)
        `function(event){ #{v.call(DOM::Event.new(`event`))} }`
      else
        v.to_n
      end
    end

    def text(content)
      @nodes << content
    end

    def clear
      @nodes = []
    end

    def t(msg)
      bound = @bound
      proc do
        bound.update msg
      end
    end

    def cmd(msg, &block)
      bound = @bound
      promise = block.call
      promise.then do |result|
        bound.update msg, result
      end
    end
  end

  module VComponent
    def self.extended(other)
      other.extend VDomBuilder
      other.extend other
    end
  end

  class VDomRenderer < DOM::Element
    extend Forwardable

    def_delegators :class, :component, :tagname

    def self.component(value = nil)
      return @component unless value
      @component = value
    end

    def self.tagname(value = nil)
      return @tagname unless value
      @tagname = value
    end

    def initialize
      super tagname
      render
    end

    def update(msg, data = nil)
      @data, cmd = component.update msg, data, @data.dup
      render
    end

    def render
      @data ||= component.init
      component.bound = self
      new_tree = component.render(@data)

      unless @old_tree
        @root_node = `virtualDom.create(#{new_tree})`
        @old_tree = new_tree
        self << @root_node
      else
        diff = `virtualDom.diff(#{@old_tree}, #{new_tree})`
        `virtualDom.patch(#{@root_node}, #{diff})`
      end
    end
  end
end
