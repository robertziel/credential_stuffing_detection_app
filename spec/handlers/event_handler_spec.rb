require 'spec_helper'

describe EventHandler do
  let(:address) { create :address, ip: params[:ip] }
  let(:event) { create :event, address: address, name: params[:event_name] }

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

    describe ' for email' do
      it { should validate_presence_of(:email) }
      it { should allow_value('hello@robertz.co').for(:email) }
      it { should_not allow_value('hello@robertzco').for(:email) }
      it { should_not allow_value('hellorobertz.co').for(:email) }
    end

    describe 'for ip' do
      it { should validate_presence_of(:ip) }
    end

    describe 'for event_name' do
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
      shared_examples :creates_event do
        it 'creates a new request' do
          expect { subject }.to change { event.requests.count }
        end

        it "assigns email's last_detected_at the same as last event's detected_at" do
          subject
          email_detected_at = event.emails.last.last_detected_at
          request_detected_at = event.requests.last.detected_at
          expect(email_detected_at).to eq request_detected_at
        end
      end

      before do
        allow_any_instance_of(EventHandler).to receive(:valid?) { true }
        allow_any_instance_of(EventHandler).to receive(:event) { event }
      end

      context 'when email exists' do
        let!(:email) { create :email, event: event, value: params[:email] }

        it 'uses existing email' do
          expect { subject }.to change { event.emails.count }.by(0)
        end

        include_examples :creates_event
      end

      context 'when email does not exist' do
        it 'creates a new email' do
          expect { subject }.to change { event.emails.count }
        end

        include_examples :creates_event
      end
    end
  end

  describe '#detected_attack?' do
    subject do
      object.detected_attack?
    end

    before do
      allow_any_instance_of(EventHandler).to receive(:address) { address }
    end

    context 'when address is banned' do
      before do
        allow_any_instance_of(EventHandler).to receive(:banned?) { true }
      end

      it 'returns true' do
        expect(subject).to be true
      end
    end

    context 'when address is not banned' do
      before do
        allow_any_instance_of(EventHandler).to receive(:banned?) { false }
      end

      context 'when reached_limits? returns true' do
        before do
          allow_any_instance_of(EventHandler).to receive(:reached_limits?) { true }
        end

        it 'returns true' do
          expect(subject).to be true
        end

        it 'calls address ban! method' do
          expect_any_instance_of(Address).to receive(:ban!).with(no_args).and_call_original
          subject
        end
      end

      context 'when reached_limits? returns false' do
        before do
          allow_any_instance_of(EventHandler).to receive(:reached_limits?) { false }
        end

        it 'returns true' do
          expect(subject).to be false
        end
      end
    end
  end

  describe '#banned?' do
    subject do
      object.send(:banned?)
    end

    before do
      address.update_column(:banned_at, banned_at)
    end
    # address.banned_at.present? && address.banned_at > CSDApp.ip_ban_time.seconds
    context 'when banned_at is nil' do
      let(:banned_at) { nil }

      it 'returns false' do
        expect(subject).to be false
      end
    end

    context 'when banned less than ip_ban_time seconds ago' do
      let(:banned_at) { (CSDApp.ip_ban_time - 1).seconds.ago }

      it 'returns true' do
        expect(subject).to be true
      end
    end

    context 'when banned more than ip_ban_time seconds ago' do
      let(:banned_at) { CSDApp.ip_ban_time.seconds.ago }

      it 'returns false' do
        expect(subject).to be false
      end
    end
  end

  describe '#reached_limits?' do
    subject do
      object.send(:reached_limits?)
    end

    context 'when emails limit reached' do
      before do
        (CSDApp.ip_emails_limit + 1).times do
          create :email, event: event
        end
      end

      context 'when requests limit reached' do
        before do
          (CSDApp.ip_requests_limit + 1).times do
            create :request, event: event
          end
        end

        it 'returns true' do
          expect(subject).to be true
        end
      end

      context 'when requests limit not reached' do
        before do
          CSDApp.ip_requests_limit.times do
            create :request, event: event
          end
        end

        it 'returns false' do
          expect(subject).to be false
        end
      end
    end
  end

  describe '#address' do
    subject do
      object.send(:address)
    end

    context 'when address exists' do
      before { address }

      it 'returns address' do
        expect(subject).to eq Address.last
      end

      it 'does not create new address' do
        expect { subject }.to change { Address.count }.by(0)
      end
    end

    context 'when address does not exist' do
      it 'returns address' do
        expect(subject).to eq Address.last
      end

      it 'creates new address' do
        expect { subject }.to change { Address.count }
      end
    end
  end

  describe '#event' do
    it ''
  end
end
