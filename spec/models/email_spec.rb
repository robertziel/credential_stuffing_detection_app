require 'spec_helper'

describe Email do
  describe 'associations' do
    it { should belong_to(:address) }
    it { should have_many(:events).dependent(:destroy) }
  end
end
