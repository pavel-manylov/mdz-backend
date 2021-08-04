require 'rails_helper'

RSpec.describe CreatePost, type: :interaction do
  it_behaves_like 'post modify interaction' do
    let(:interaction_params) do
      {
        name: post_name,
        seo_url: post_seo_url
      }
    end

    describe '.run' do
      it 'creates new post' do
        expect { outcome }.to change { Post.count }.by 1
      end

      it 'has created post as a result' do
        expect(outcome.result).to be_a Post
        expect(outcome.result).to be_persisted
      end
    end
  end
end