require 'fron'

describe Fron::Configuration do

	subject { described_class.new }

	describe '#initialize' do
		it 'should create a logger' do
			subject.logger.class.should be Fron::Logger
		end

		it 'should create the application container' do
			subject.app.class.should be Fron::Configuration::App
		end

		it 'should create the yield container' do
			subject.main.class.should be Fron::Configuration::Yield
		end
	end
end
