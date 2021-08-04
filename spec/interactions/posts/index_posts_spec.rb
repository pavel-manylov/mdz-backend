require 'rails_helper'

RSpec.describe IndexPosts, type: :interaction do
  subject(:outcome) { described_class.run interaction_params }
  let(:interaction_params) do
    { }
  end

  let!(:posts) { create_list :post, 3 }

  example '.run returns all posts as a result' do
    expect(outcome.result).to match_array posts
  end
end