require 'spec_helper'

describe EventHandler do
  let(:object) { described_class.new({}) }

  describe '#validations' do
    subject { object }

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

  describe '#save' do
    subject do
      object.save
    end

    context 'not valid' do
      before do
        allow_any_instance_of(EventHandler).to receive(:valid?) { false }
      end

      it 'returns false' do
        expect(subject).to eq false
      end
    end

    context 'valid' do
      it ''
    end
  end

  describe '#detected_attack?' do
    it ''
  end
end
