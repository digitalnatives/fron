require 'fron/dom'

describe DOM::NodeList do

  describe '#initialize' do
    it 'should map nodes to elements' do
      DOM::Document.body.children.each do |node|
        node.class.should eq DOM::NODE
      end
    end
  end
end
