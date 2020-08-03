shared_examples :finds_or_creates do |object_name|
  let(:model_class) { object_name.to_s.camelize.constantize }

  subject do
    object.send(object_name)
  end

  context 'when record exists' do
    before { send(object_name) }

    it 'returns record' do
      expect(subject).to eq model_class.last
    end

    it 'does not create new record' do
      expect { subject }.to change { model_class.count }.by(0)
    end
  end

  context 'when record does not exist' do
    it 'returns record' do
      expect(subject).to eq model_class.last
    end

    it 'creates new record' do
      expect { subject }.to change { model_class.count }
    end
  end
end
