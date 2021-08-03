require 'rails_helper'

RSpec.describe IndexComponents, type: :interaction do
  subject(:outcome) { described_class.run interaction_params }
  let(:interaction_params) do
    { post_id: post_id }
  end

  let(:post_id) { post.id }
  let(:post) { create :post }
  let!(:components) { create_list :component, 3, post: post }

  example '.run returns components of requested Post as a result' do
    expect(outcome.result).to match_array components
  end

  describe 'Validation' do
    context 'with unknown referenced post' do
      let(:post_id) { (Post.maximum(:id) || 0) + 1000 }

      it_behaves_like 'invalid', :post_id, validate: false
    end
  end
end