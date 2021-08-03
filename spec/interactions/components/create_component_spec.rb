require 'rails_helper'

RSpec.describe CreateComponent, type: :interaction do
  it_behaves_like 'component modify interaction' do
    let(:interaction_params) do
      {
        public: component_public,
        type: component_type,
        value: component_value,
        order: component_order,
        post_id: component_post_id,
        display_class: component_display_class,
        custom_fields: component_custom_fields
      }
    end

    let(:component_post_id){ component_post.id }
    let(:component_post){ create :post }

    describe '.run' do
      it 'creates new component' do
        expect { outcome }.to change { Component.count }.by 1
      end

      context 'created component' do
        subject(:created_component) { outcome.result.reload }

        it 'is linked to passed #post' do
          expect(created_component.post).to eq component_post
        end
      end
    end

    describe 'Validation' do
      example 'foolproof check' do
        expect(outcome).to be_valid
      end

      context 'with unknown post' do
        let(:component_post_id) { (Post.maximum(:id) || 0) + 1000 }

        it_behaves_like 'invalid', :post_id, validate: false
      end
    end
  end
end