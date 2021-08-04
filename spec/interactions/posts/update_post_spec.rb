require 'rails_helper'

RSpec.describe UpdatePost, type: :interaction do
  it_behaves_like 'post modify interaction' do
    let(:interaction_params) do
      {
        post_id: post_id,
        name: post_name,
        seo_url: post_seo_url
      }
    end

    let(:post) { create :post }
    let(:post_id) { post.id }

    describe '.run' do
      it 'has an updated post as a result' do
        expect(outcome.result).to eq post
        expect(outcome.result).to be_persisted
      end

      it 'does not update components' do
        create_list :component, 3, post: post
        expect { outcome }.not_to change { Component.count }
      end
    end
  end
end