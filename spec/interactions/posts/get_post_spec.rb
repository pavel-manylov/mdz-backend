require 'rails_helper'

RSpec.describe GetPost, type: :interaction do
  subject(:outcome) { described_class.run interaction_params }
  let(:interaction_params) do
    { post_id: post_id }
  end

  let(:post_id) { post.id }
  let(:post) { create :post }

  example '.run returns requested Post as a result' do
    expect(outcome.result).to eql post
  end

  describe 'Validation' do
    context 'with unknown referenced post' do
      let(:post_id) { (Post.maximum(:id) || 0) + 1000 }

      it_behaves_like 'invalid', :post_id, validate: false
    end
  end
end