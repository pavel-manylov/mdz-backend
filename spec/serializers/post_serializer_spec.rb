require 'rails_helper'

RSpec.describe PostSerializer, type: :serializer do
  describe '.serialize' do
    subject(:serialized) { described_class.serialize post }

    let(:post) do
      create :post, name: post_name, seo_url: post_seo_url
    end
    let(:post_name) { 'Тестовая публикация' }
    let(:post_seo_url) { 'test-post' }

    it 'returns Hash' do
      expect(serialized).to be_a Hash
    end

    context 'returned Hash' do
      example '["id"] equals post id' do
        expect(serialized['id']).to eql post.id
      end

      example '["name"] equals post name' do
        expect(serialized['name']).to eql post_name
      end

      example '["seo_url"] equals post seo url' do
        expect(serialized['seo_url']).to eql post_seo_url
      end
    end
  end
end