require 'rails_helper'

RSpec.describe CreatePost, type: :interaction do
  subject(:outcome) { described_class.run interaction_params }

  let(:interaction_params) do
    {
      name: new_post_name,
      seo_url: new_post_seo_url
    }
  end
  let(:new_post_name) { 'Новый пост 123' }
  let(:new_post_seo_url) { 'new-post-123' }

  describe '.run' do
    it 'creates new post' do
      expect { outcome }.to change { Post.count }.by 1
    end

    it 'has created post as a result' do
      expect(outcome.result).to be_a Post
      expect(outcome.result).to be_persisted
    end

    context 'created post' do
      subject(:created_post) { outcome.result }

      it 'has passed #name' do
        expect(created_post.name).to eql new_post_name
      end

      it 'has passed #seo_url' do
        expect(created_post.seo_url).to eql new_post_seo_url
      end

    end
  end

  describe 'Validation' do
    example 'foolproof check' do
      expect(outcome).to be_valid
    end

    context 'without #name' do
      let(:new_post_name) { '' }
      it_behaves_like 'invalid', :name, validate: false
    end
  end
end