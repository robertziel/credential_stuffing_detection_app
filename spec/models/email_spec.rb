require 'spec_helper'

describe Email do
  describe 'associations' do
    it { should belong_to(:event) }
  end
end
