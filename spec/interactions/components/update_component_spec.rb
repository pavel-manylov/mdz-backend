require 'rails_helper'

RSpec.describe UpdateComponent, type: :interaction do
  it_behaves_like 'component modify interaction' do
    let(:interaction_params) do
      {
        component_id: component_id,
        public: component_public,
        type: component_type,
        value: component_value,
        order: component_order,
        post_id: component_post_id,
        display_class: component_display_class,
        custom_fields: component_custom_fields
      }
    end

    let(:component_post_id) { component_post.id }
    let(:component_id) { component.id }

    let(:component_post) { component.post }
    let(:component) { create :component }

    describe '.run' do
      it 'has an updated component as a result' do
        expect(outcome.result).to eq component
        expect(outcome.result).to be_persisted
      end

      context 'custom fields update' do
        let(:component_custom_fields) do
            {
              'x-mobile' => 'android',
              'best-book' => 'заповедник'
            }
        end

        let!(:to_be_destroyed_custom_field) do
          create :custom_field, component: component, name: 'visibility', value: 'main-screen'
        end

        let!(:to_be_updated_custom_field) do
          create :custom_field, component: component, name: 'x-mobile', value: 'ios'
        end

        before do
          expect(outcome).to be_valid
        end # foolproof check

        it 'deletes obsolete custom fields' do
          expect{ to_be_destroyed_custom_field.reload }.to raise_error ActiveRecord::RecordNotFound
        end

        it 'updates changed custom fields' do
          expect(to_be_updated_custom_field.reload.value).to eq 'android'
        end

        it 'creates new fields' do
          expect(component.reload.custom_fields).to include have_attributes(name: 'best-book', value: 'заповедник')
        end
      end
    end
  end
end