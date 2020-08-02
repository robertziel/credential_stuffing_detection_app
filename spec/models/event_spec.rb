require 'spec_helper'

describe Event do
  describe 'associations' do
    it { should belong_to(:address) }
    it { should have_many(:emails).dependent(:destroy) }
    it { should have_many(:requests).dependent(:destroy) }
  end
end
