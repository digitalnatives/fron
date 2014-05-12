describe DOM::Window do

  subject { described_class }

  describe "#hash" do
    it 'should return the hash of the url' do
      `window.location.hash = 'test'`
      subject.hash.should eq 'test'
    end
  end

  describe "#hash=" do
    it 'should set the hash of the url' do
      subject.hash = 'test'
      `window.location.hash.slice(1)`.should eq 'test'
    end
  end

  describe "scrollY" do
    it 'should return the vertical scroll position' do
      subject.scrollY.should eq 0
    end
  end

  describe "scrollX" do
    it 'should return the horizontal scroll position' do
      subject.scrollX.should eq 0
    end
  end
end
