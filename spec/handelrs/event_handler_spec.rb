require 'spec_helper'

describe EventHandler do
  describe '#validations' do
    subject do
      described_class.new({})
    end

    describe '#email' do
      it { should validate_presence_of(:email) }
      it { should allow_value('hello@robertz.co').for(:email) }
      it { should_not allow_value('hello@robertzco').for(:email) }
      it { should_not allow_value('hellorobertz.co').for(:email) }
    end

    describe '#ip' do
      it { should validate_presence_of(:ip) }
    end

    describe '#name' do
      it { should validate_presence_of(:name) }
    end
  end
end
