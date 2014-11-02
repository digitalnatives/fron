require 'forwardable'

module DOM
  # Node List
  class NodeList
    include Enumerable
    extend Forwardable

    def_delegators :@nodes, :length, :include?, :each, :index, :[]

    # Initializes the node list
    #
    # @param nodes [Array] Array of nodes
    def initialize(nodes)
      @nodes = nodes.map { |node| DOM::Element.fromNode node }
    end
  end
end
