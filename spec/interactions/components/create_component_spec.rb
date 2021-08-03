require 'rails_helper'

RSpec.describe CreateComponent, type: :interaction do
  subject(:outcome) { described_class.run interaction_params }

  let(:interaction_params) do
    {
      public: new_component_public,
      type: new_component_type,
      value: new_component_value,
      order: new_component_order,
      post_id: new_component_post_id,
      custom_fields: new_component_custom_fields
    }
  end

  let(:new_component_custom_fields) do
    {
      'mobile-class' => 'xLarge',
      'as-preview' => 'true'
    }
  end
  let(:new_component_public) { true }
  let(:new_component_type) { 'boolean' }
  let(:new_component_value) { true }
  let(:new_component_order) { 55 }
  let(:new_component_post_id) { new_component_post.id }

  let(:new_component_post) { create(:post) }


  describe '.run' do
    it 'creates new component' do
      expect { outcome }.to change { Component.count }.by 1
    end

    it 'has a component as a result' do
      expect(outcome.result).to be_a Component
      expect(outcome.result).to be_persisted
    end

    context 'created component' do
      subject(:created_component) { outcome.result.reload }

      it 'is linked to passed #post' do
        expect(created_component.post).to eq new_component_post
      end

      it 'has passed #public flag' do
        expect(created_component.public).to be new_component_public
      end

      it 'has passed #order' do
        expect(created_component.order).to eq new_component_order
      end

      context 'representative value' do
        subject(:representative_value) { created_component.value.value }

        context 'with passed boolean value' do
          let(:new_component_type) { 'boolean' }
          let(:new_component_value) { true }

          it 'has boolean representative value' do
            expect(representative_value).to be new_component_value
          end
        end

        context 'with passed string value' do
          let(:new_component_type) { 'string' }
          let(:new_component_value) { 'test string value' }

          it 'has string representative value' do
            expect(representative_value).to eql new_component_value
          end
        end

        context 'with passed relation value' do
          let(:new_component_type) { 'relation' }
          let(:new_component_value) do
            posts.map { |post| { 'id' => post.id } }
          end
          let(:posts) { create_list :post, 3 }

          it 'has correct posts linked as representative value' do
            expect(representative_value).to match_array posts
          end
        end
      end

      it 'sets custom fields' do
        expect(
          created_component.custom_fields
        ).to match_array [
                           have_attributes(name: 'mobile-class', value: 'xLarge'),
                           have_attributes(name: 'as-preview', value: 'true')
                         ]
      end
    end
  end

  describe 'Validation' do
    example 'foolproof check' do
      expect(outcome).to be_valid
    end

    context 'with unknown post' do
      let(:new_component_post_id) { (Post.maximum(:id) || 0) + 1000 }

      it_behaves_like 'invalid', :post_id, validate: false
    end

    context 'with non-boolean value for public flag' do
      let(:new_component_public) { 'notbooleanatall' }

      it_behaves_like 'invalid', :public, validate: false
    end

    context 'with non-integer value for order' do
      let(:new_component_order) { 'abc' }

      it_behaves_like 'invalid', :order, validate: false
    end

    context 'with order less than zero' do
      let(:new_component_order) { -5 }

      it_behaves_like 'invalid', :order, validate: false
    end

    context 'with unknown type' do
      let(:new_component_type) { 'massive_attack' }

      it_behaves_like 'invalid', :type, validate: false
    end

    context 'with non-boolean value for boolean type' do
      let(:new_component_type) { 'boolean' }
      let(:new_component_value) { 'nonbool' }

      it_behaves_like 'invalid', :value, validate: false
    end

    context 'with non-string value for string type' do
      let(:new_component_type) { 'string' }
      let(:new_component_value) { true }

      it_behaves_like 'invalid', :value, validate: false
    end

    context 'with non-references values for relation type' do
      let(:new_component_type) { 'relation' }
      let(:new_component_value) do
        [{ 'non_id' => 123 }]
      end

      it_behaves_like 'invalid', :value, validate: false
    end

    context 'with unknown referenced post(s) as a value' do
      let(:new_component_type) { 'relation' }
      let(:new_component_value) do
        [{ 'id' => (Component.maximum(:id) || 0) + 1000 }]
      end

      it_behaves_like 'invalid', :value, validate: false
    end

    context 'without key for custom field' do
      let(:new_component_custom_fields) do
        { '' => 'value' }
      end

      it_behaves_like 'invalid', :custom_fields, validate: false
    end

    context 'without value for custom field' do
      let(:new_component_custom_fields) do
        { 'key' => '' }
      end

      it_behaves_like 'invalid', :custom_fields, validate: false
    end
  end
end