require 'rails_helper'

RSpec.describe ComponentSerializer, type: :serializer do
  describe '.serialize' do
    subject(:serialized) { described_class.serialize component }

    let(:component) do
      create :component,
             value: component_value,
             public: component_public,
             custom_fields: component_custom_fields,
             display_class: component_display_class,
             order: component_order,
             post: component_post
    end

    let(:component_value) { build :boolean_value, value: true }
    let(:component_public) { true }
    let(:component_custom_fields) do
      [
        build(:custom_field, name: 'hide-on-mobile', value: 'yes')
      ]
    end
    let(:component_display_class) { 'heading1' }
    let(:component_order) { 25 }
    let(:component_post) { create :post }

    it 'returns Hash' do
      expect(serialized).to be_a Hash
    end

    shared_examples_for 'hash internals' do
      example '["id"] equals component id' do
        expect(serialized_item['id']).to eql component.id
      end

      example '["display_class"] equals component display class' do
        expect(serialized_item['display_class']).to eql component_display_class
      end

      example '["order"] equals component order' do
        expect(serialized_item['order']).to eql component_order
      end

      example '["public"] equals component public flag' do
        expect(serialized_item['public']).to be component_public
      end

      example '["post_id"] equals associated post id' do
        expect(serialized_item['post_id']).to eql component_post.id
      end

      example '["custom_fields"] is a hash-representation of custom fields' do
        expect(serialized_item['custom_fields']).to eq({ 'hide-on-mobile' => 'yes' })
      end

      context 'with BooleanValue' do
        example '["type"] equals "boolean"' do
          expect(serialized_item['type']).to eql 'boolean'
        end

        example '["value"] equals boolean value' do
          expect(serialized_item['value']).to be true
        end
      end

      context 'with StringValue' do
        let(:component_value) { build :string_value, value: component_string_value }
        let(:component_string_value) { 'that is a value' }

        example '["type"] equals "string"' do
          expect(serialized_item['type']).to eql 'string'
        end

        example '["value"] equals string value' do
          expect(serialized_item['value']).to eql component_string_value
        end
      end

      context 'with RelationValue' do
        let(:component_value) { build :relation_value, posts: [first_post, second_post] }
        let(:first_post) { create :post }
        let(:second_post) { create :post }

        example '["type"] equals "relation"' do
          expect(serialized_item['type']).to eql 'relation'
        end

        example '["value"] is an array of hashes with posts references' do
          expect(serialized_item['value']).to eq([
                                              { 'post_id' => first_post.id },
                                              { 'post_id' => second_post.id }
                                            ])
        end
      end
    end

    context 'returned Hash' do
      it_behaves_like 'hash internals' do
        subject(:serialized_item){ serialized }
      end
    end

    context 'with an Array of Component(s)' do
      subject(:serialized) { described_class.serialize [create(:component), component] }

      it 'returns an Array of Hash(es)' do
        expect(serialized).to be_an Array
        expect(serialized[0]).to be_a Hash
      end

      it 'has an item for each Component' do
        expect(serialized.size).to eql 2
      end

      context 'each Hash' do
        it_behaves_like 'hash internals' do
          subject(:serialized_item){ serialized[1] }
        end
      end
    end
  end
end