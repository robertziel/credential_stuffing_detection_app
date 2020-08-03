require 'spec_helper'

describe Address do
  let(:address) { create :address }

  describe '#associations' do
    it { should have_many(:events).dependent(:destroy) }
  end

  describe '#ban!' do
    subject do
      address.ban!
    end

    it 'sets banned_at' do
      address.update_column(:banned_at, nil)
      subject
      expect(address.banned_at).not_to eq nil
    end
  end
end
