require 'spec_helper'

describe CSDApp do
  describe 'PUT /detect' do
    subject do
      put '/detect', params
    end

    context 'not valid params' do
      let(:params) { {} }

      it 'returns errors' do
        subject
        expect(last_response).to be_ok
        expect(last_response_body_to_json[:errors]).not_to eq nil
      end
    end

    context 'valid params' do
      let(:params) do
        {
          email: 'hello@robertz.co',
          event_name: 'log_in',
          ip: '0.0.0.0'
        }
      end

      it 'returns detected_attack' do
        value = 'value'
        allow(Input).to receive(:detected_attack?).with(params) { value }

        subject
        expect(last_response).to be_ok
        expect(last_response_body_to_json[:detected_attack]).to eq value
      end
    end
  end
end
