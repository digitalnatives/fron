require 'forwardable'

module DOM
  class NodeList
    include Enumerable
    extend Forwardable

    def_delegators :@nodes, :length, :include?, :each, :index, :[]

    def initialize(nodes)
      @nodes = nodes.map { |node| DOM::NODE.new node }
    end
  end
end
