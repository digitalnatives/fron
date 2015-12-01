require 'spec_helper'

describe Date do
  context 'Class' do
    subject { described_class }

    describe '#this_week' do
      it 'should return this week' do
        week = subject.this_week
        week.should be_a Range
        week.count.should eq 7
      end
    end

    describe '#last_week' do
      it 'should return last week' do
        week = subject.last_week
        week.should be_a Range
        week.count.should eq 7
      end
    end

    describe '#monday' do
      it 'should return monday' do
        monday = subject.monday
        monday.strftime('%A').should eq 'Monday'
      end
    end

    describe '#week' do
      it 'should return a week' do
        week = subject.week
        week.should be_a Range
        week.count.should eq 7
      end
    end
  end

  subject { described_class.new 1987, 05, 28 }

  describe '#beginning_of_month' do
    it 'should return the beginning of the month' do
      date = subject.beginning_of_month
      date.to_s.should eq '1987-05-01'
    end
  end

  describe '#end_of_month' do
    it 'should return the end of the month' do
      date = subject.end_of_month
      date.to_s.should eq '1987-05-31'
    end
  end
end
