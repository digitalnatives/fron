require 'spec_helper'
require 'fron/utils/render_proc'

describe Fron::RenderProc do
  let(:method) { proc {} }
  let(:logger) { double }

  subject { described_class.new method, true }

  it 'should call the method' do
    subject.should receive(:logger).and_return logger
    logger.should receive(:info)
    method.should receive(:owner).and_return 'test'
    method.should receive(:call)
    subject.should receive(:request_animation_frame).and_yield
    subject.call
  end
end
