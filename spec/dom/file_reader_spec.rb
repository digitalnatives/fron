require 'spec_helper'

describe DOM::FileReader do
  let(:file) { `{ native: {} }` }

  describe '#read_as_data_url' do
    it 'should return data url' do
      subject.read_as_data_url(file).should_not be nil
    end
  end
end
