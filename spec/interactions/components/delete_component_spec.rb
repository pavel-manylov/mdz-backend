require 'rails_helper'

RSpec.describe DeleteComponent, type: :interaction do
  subject(:outcome) { described_class.run interaction_params }
  let(:interaction_params) do
    {
      component_id: component_id
    }
  end
  let(:component) { create :component }
  let(:component_id) { component.id }

  describe '.run' do
    it 'returns true as a result' do
      expect(outcome.result).to be true
    end

    it 'destroys referenced Component' do
      outcome
      expect { component.reload }.to raise_error ActiveRecord::RecordNotFound
    end

    it 'destroys associated *Value(s)' do
      outcome
      expect { component.value.reload }.to raise_error ActiveRecord::RecordNotFound
    end
  end

  describe 'Validation' do
    context 'with unknown referenced component' do
      let(:component_id) { (Component.maximum(:id) || 0) + 1000 }

      it_behaves_like 'invalid', :component_id, validate: false
    end
  end
end