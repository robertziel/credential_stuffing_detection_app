require 'spec_helper'

describe CSDApp do
  describe '#PUT /detect' do
    let(:params) do
      {
        email: 'hello@robertz.co',
        event_name: 'log_in',
        ip: '0.0.0.0'
      }
    end

    subject do
      put '/detect', params
    end

    it 'initializes EventHandler with params' do
      expect(EventHandler).to receive(:new).with(params).and_call_original
      subject
    end

    context 'when not valid params' do
      before do
        allow_any_instance_of(EventHandler).to receive(:save) { false }
      end

      it 'returns errors' do
        errors = 'errors'
        allow_any_instance_of(ActiveModel::Errors).to receive(:messages) { errors }

        subject
        expect(last_response).to be_ok
        expect(last_response_body_to_json[:errors]).to eq errors
      end
    end

    context 'when valid params' do
      before do
        allow_any_instance_of(EventHandler).to receive(:save) { true }
      end

      it 'returns detected_attack' do
        value = 'value'
        allow_any_instance_of(EventHandler).to receive(:detected_attack?) { value }

        subject
        expect(last_response).to be_ok
        expect(last_response_body_to_json[:detected_attack]).to eq value
      end
    end
  end
end
