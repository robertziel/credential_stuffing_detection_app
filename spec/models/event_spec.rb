require 'spec_helper'

describe Event do
  describe 'associations' do
    it { should belong_to(:email) }
  end
end
