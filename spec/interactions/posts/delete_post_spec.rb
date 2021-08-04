require 'rails_helper'

RSpec.describe DeletePost, type: :interaction do
  subject(:outcome) { described_class.run interaction_params }
  let(:interaction_params) do
    {
      post_id: post_id
    }
  end
  let(:post) { create :post }
  let(:post_id) { post.id }

  describe '.run' do
    it 'returns true as a result' do
      expect(outcome.result).to be true
    end

    it 'destroys referenced Post' do
      outcome
      expect { post.reload }.to raise_error ActiveRecord::RecordNotFound
    end

    it 'destroys associated Component(s)' do
      create_list :component, 3, post: post
      expect { outcome }.to change { Component.count }.by -3
    end
  end

  describe 'Validation' do
    context 'with unknown referenced post' do
      let(:post_id) { (Post.maximum(:id) || 0) + 1000 }

      it_behaves_like 'invalid', :post_id, validate: false
    end
  end
end