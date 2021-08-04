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

    shared_examples_for 'hash internals' do
      example '["id"] equals post id' do
        expect(serialized_item['id']).to eql post.id
      end

      example '["name"] equals post name' do
        expect(serialized_item['name']).to eql post_name
      end

      example '["seo_url"] equals post seo url' do
        expect(serialized_item['seo_url']).to eql post_seo_url
      end
    end

    context 'returned Hash' do
      it_behaves_like 'hash internals' do
        subject(:serialized_item) { serialized }
      end
    end

    context 'with an Array of Post(s)' do
      subject(:serialized) { described_class.serialize [create(:post), post] }

      it 'returns an Array of Hash(es)' do
        expect(serialized).to be_an Array
        expect(serialized[0]).to be_a Hash
      end

      it 'has an item for each Post' do
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