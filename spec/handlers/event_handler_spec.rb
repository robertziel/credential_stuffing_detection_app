require 'spec_helper'

describe EventHandler do
  let(:object) { described_class.new(params) }
  let(:params) do
    {
      email: 'hello@robertz.co',
      event_name: 'log_in',
      ip: '0.0.0.0'
    }
  end

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

    describe '#event_name' do
      it { should validate_presence_of(:event_name) }
    end
  end

  describe '#save' do
    subject do
      object.save
    end

    context 'when params not valid' do
      before do
        allow_any_instance_of(EventHandler).to receive(:valid?) { false }
      end

      it 'returns false' do
        expect(subject).to eq false
      end
    end

    context 'when params valid' do
      let(:address) { create :address, ip: params[:ip] }

      shared_examples :creates_event do
        it 'creates a new event' do
          expect { subject }.to change { address.events.count }
        end

        it "assigns email's last_detected_at the same as last event's detected_at" do
          subject
          email = address.emails.last
          expect(email.last_detected_at).to eq email.events.last.detected_at
        end
      end

      before do
        allow_any_instance_of(EventHandler).to receive(:valid?) { true }
        allow_any_instance_of(EventHandler).to receive(:address) { address }
      end

      context 'when email exists' do
        let!(:email) { create :email, address: address, value: params[:email] }

        it 'uses existing email' do
          expect { subject }.to change { address.emails.count }.by(0)
        end

        include_examples :creates_event
      end

      context 'when email does not exist' do
        it 'creates a new email' do
          expect { subject }.to change { address.emails.count }
        end

        include_examples :creates_event
      end
    end
  end

  describe '#detected_attack?' do
    it ''
  end

  describe '#address' do
    it ''
  end
end
