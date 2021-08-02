require 'rails_helper'

RSpec.describe CreatePost, type: :interaction do
  subject(:create_post) do
    described_class.new name: new_post_name,
                        seo_url: new_post_seo_url
  end

  let(:new_post_name) { 'Новый пост 123' }
  let(:new_post_seo_url) { 'new-post-123' }

  describe '#execute' do
    subject(:execute) { create_post.execute }

    it 'creates new post' do
      expect { execute }.to change { Post.count }.by 1
    end

    it 'returns created post' do
      expect(execute).to be_a Post
      expect(execute).to be_persisted
    end

    context 'created post' do
      subject(:created_post) { execute }

      it 'has passed #name' do
        expect(created_post.name).to eql new_post_name
      end

      it 'has passed #seo_url' do
        expect(created_post.seo_url).to eql new_post_seo_url
      end

    end
  end

  describe 'Validation' do
    context 'without #name' do
      before { create_post.name = '' }
      it_behaves_like 'invalid', :name
    end
  end
end