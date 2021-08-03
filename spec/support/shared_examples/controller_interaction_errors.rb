shared_examples_for 'controller interaction errors' do |interaction_class: nil|
  context 'with interaction validation errors' do
    before do
      error = ActiveInteraction::InvalidInteractionError.new
      error.interaction = interaction_with_errors
      allow(interaction_class).to receive(:run!).and_raise(error)
    end

    let(:interaction_with_errors) do
      double ActiveInteraction::Base, errors: double(to_a: readable_errors)
    end

    let(:readable_errors) { ['Name is required'] }

    before{ create }

    it 'returns status code 422' do
      expect(response.status).to eq 422
    end

    example 'body includes all errors' do
      expect(JSON.parse(response.body)).to eq({ 'errors' => readable_errors})
    end
  end

  context 'with interaction exception' do
    before do
      allow(interaction_class).to receive(:run!).and_raise(ActiveInteraction::Error)
    end

    before{ create }

    it 'returns status code 500' do
      expect(response.status).to eq 500
    end

    example 'body includes some error message' do
      expect(JSON.parse(response.body)['errors']).to be_present
    end
  end

  context 'with other exception' do
    before do
      allow(interaction_class).to receive(:run!).and_raise(StandardError)
    end

    before{ create }

    it 'returns status code 500' do
      expect(response.status).to eq 500
    end

    example 'body includes some error message' do
      expect(JSON.parse(response.body)['errors']).to be_present
    end
  end
end