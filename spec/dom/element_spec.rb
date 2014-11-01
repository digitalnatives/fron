require 'spec_helper'

describe DOM::Element do

  subject  { described_class.new 'div' }
  let(:el) { subject.instance_variable_get('@el') }
  let(:a)  { described_class.new 'a' }

  describe '#initailize' do
    context 'string argument' do
      it 'should create an element with tagname' do
        described_class.new('div').tag.should eq 'div'
      end

      it 'should add classes' do
        el = described_class.new('div.test.help')
        el.hasClass('test').should be true
        el.hasClass('help').should be true
      end

      it 'should set the id' do
        el = described_class.new('div#test')
        el.id.should eq 'test'
      end

      it 'should set attributes' do
        el = described_class.new('div[href=test][link=rel]')
        el['href'].should eq 'test'
        el['link'].should eq 'rel'
      end
    end

    context 'node argument' do
      it 'should link given node' do
        el = described_class.new `document.body`
        el.tag.should eq 'body'
      end
    end

    context 'other argument' do
      it 'should throw error' do
        expect(proc { described_class.new({}) }).to raise_error
      end
    end
  end

  describe '#matches' do
    it 'should return if matches selector' do
      subject.matches('div').should be true
    end

    it 'should return flase unless matches selector' do
      subject.matches('body').should be false
    end
  end

  describe '#hide' do
    it 'should hide the element' do
      subject.hide
      subject.style.display.should eq 'none'
    end
  end

  describe '#show' do
    it 'should show the element' do
      subject.show
      subject.style.display.should eq 'block'
    end
  end

  describe '#[]' do
    it 'should return the given attribute value' do
      `#{el}.setAttribute('test','data')`
      subject['test'].should eq 'data'
    end
  end

  describe '#[]=' do
    it 'should set the given attribute with the given value' do
      subject['test'] = 'data'
      `#{el}.getAttribute('test')`.should eq 'data'
    end
  end

  describe '#find' do
    it 'should find a descendant element' do
      a >> subject
      subject.find('a').should eq a
    end

    it 'should return nil if no element is found' do
      subject.find('p').should eq nil
    end
  end

  describe '#html' do
    it 'should get the html of the element' do
      `#{el}.innerHTML = 'test'`
      subject.html.should eq 'test'
    end
  end

  describe '#html=' do
    it 'should set the html of the element' do
      subject.html = 'test'
      `#{el}.innerHTML`.should eq 'test'
    end
  end

  describe '#empty' do
    it 'should empty the element' do
      subject << a
      subject.empty
      subject.children.length.should eq 0
      subject.html.should eq ''
    end
  end

  describe '#value' do
    it 'should get the value of the element' do
      `#{el}.value = 'test'`
      subject.value.should eq 'test'
    end
  end

  describe '#value=' do
    it 'should set the value of the element' do
      subject.value = 'test'
      `#{el}.value`.should eq 'test'
    end
  end

  describe '#checked' do
    it 'should return false unless the element is checked' do
      subject.checked.should be false
    end

    it 'should return true if the element is checked' do
      `#{el}.checked = true`
      subject.checked.should be true
    end
  end

  describe '#checked=' do
    it 'should set the checked property' do
      subject.checked = true
      `#{el}.checked == true`
    end
  end

  describe '#tag' do
    it 'should return the elements tagName' do
      subject.tag.should eq 'div'
      a.tag.should eq 'a'
    end
  end

  describe '#id' do
    it 'should return the id of the element' do
      `#{el}.id = 'test'`
      subject.id.should eq 'test'
    end
  end
end
