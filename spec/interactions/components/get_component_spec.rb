require 'rails_helper'

RSpec.describe GetComponent, type: :interaction do
  subject(:outcome) { described_class.run interaction_params }
  let(:interaction_params) do
    { component_id: component_id }
  end

  let(:component_id) { component.id }
  let(:component) { create :component }

  example '.run returns requested Component as a result' do
    expect(outcome.result).to eql component
  end

  describe 'Validation' do
    context 'with unknown referenced component' do
      let(:component_id) { (Component.maximum(:id) || 0) + 1000 }

      it_behaves_like 'invalid', :component_id, validate: false
    end
  end
end