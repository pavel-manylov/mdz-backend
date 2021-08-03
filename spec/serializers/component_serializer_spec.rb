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

    context 'returned Hash' do
      example '["id"] equals component id' do
        expect(serialized['id']).to eql component.id
      end

      example '["display_class"] equals component display class' do
        expect(serialized['display_class']).to eql component_display_class
      end

      example '["order"] equals component order' do
        expect(serialized['order']).to eql component_order
      end

      example '["public"] equals component public flag' do
        expect(serialized['public']).to be component_public
      end

      example '["post_id"] equals associated post id' do
        expect(serialized['post_id']).to eql component_post.id
      end

      example '["custom_fields"] is a hash-representation of custom fields' do
        expect(serialized['custom_fields']).to eq({ 'hide-on-mobile' => 'yes' })
      end

      context 'with BooleanValue' do
        example '["type"] equals "boolean"' do
          expect(serialized['type']).to eql 'boolean'
        end

        example '["value"] equals boolean value' do
          expect(serialized['value']).to be true
        end
      end

      context 'with StringValue' do
        let(:component_value) { build :string_value, value: component_string_value }
        let(:component_string_value) { 'that is a value' }

        example '["type"] equals "string"' do
          expect(serialized['type']).to eql 'string'
        end

        example '["value"] equals string value' do
          expect(serialized['value']).to eql component_string_value
        end
      end

      context 'with RelationValue' do
        let(:component_value) { build :relation_value, posts: [first_post, second_post] }
        let(:first_post) { create :post }
        let(:second_post) { create :post }

        example '["type"] equals "relation"' do
          expect(serialized['type']).to eql 'relation'
        end

        example '["value"] is an array of hashes with posts references' do
          expect(serialized['value']).to eq([
                                              { 'post_id' => first_post.id },
                                              { 'post_id' => second_post.id }
                                            ])
        end
      end

    end
  end
end