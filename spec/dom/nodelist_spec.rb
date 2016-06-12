require 'spec_helper'

describe DOM::NodeList do
  describe '#initialize' do
    it 'should map nodes to elements' do
      DOM::Document.body.children.each do |node|
        node.should be_a DOM::NODE
      end
    end
  end
end
