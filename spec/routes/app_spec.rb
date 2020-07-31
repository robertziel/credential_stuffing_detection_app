require 'spec_helper'

describe CSDApp do
  describe 'PUT /detect' do
    subject do
      put '/detect'
    end

    it 'returns result value' do
      subject
      expect(last_response).to be_ok

      response_json = last_response_body_to_json
      expect(response_json[:result]).to eq false
    end
  end
end
