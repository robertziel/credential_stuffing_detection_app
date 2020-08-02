require 'spec_helper'

describe Address do
  describe '#associations' do
    it { should have_many(:events).dependent(:destroy) }
  end

  describe '#ban!' do
    it ''
  end
end
