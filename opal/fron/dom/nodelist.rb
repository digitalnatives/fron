require 'forwardable'

module DOM
  # Node List
  class NodeList
    include Enumerable
    extend Forwardable

    # @return [Array] The nodes
    attr_reader :nodes

    def_delegators :@nodes, :length, :include?, :each, :index, :[], :to_a, :last, :empty?

    # Initializes the node list
    #
    # @param nodes [Array] Array of nodes
    def initialize(nodes)
      @nodes = nodes.map { |node| DOM::Element.from_node node }
    end
  end
end
