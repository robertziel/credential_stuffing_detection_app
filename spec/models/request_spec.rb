require 'spec_helper'

describe Request do
  describe 'associations' do
    it { should belong_to(:event) }
  end
end
