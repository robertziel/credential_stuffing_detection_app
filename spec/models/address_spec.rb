require 'spec_helper'

describe Address do
  describe 'associations' do
    it { should have_many(:emails).dependent(:destroy) }
  end
end
