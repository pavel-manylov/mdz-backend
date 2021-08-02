require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  describe "CREATE post" do
    subject(:create) { post :create, params: params }

    let(:params) do
      { name: new_post_name, seo_url: new_post_seo_url }
    end

    let(:new_post_name) { 'new_post_name' }
    let(:new_post_seo_url) { 'new_post_seo_url' }

    let(:new_post) { double Post }
    let(:serialized_new_post) do
      {
        'name' => new_post_name,
        'seo_url' => new_post_seo_url
      }
    end

    before do
      allow(CreatePost).to receive(:run!).and_return new_post
      allow(PostSerializer).to receive(:serialize).with(new_post).and_return serialized_new_post
    end

    it 'creates new post' do
      create

      expect(CreatePost).to have_received(:run!).with(name: new_post_name, seo_url: new_post_seo_url)
    end

    it 'returns serialized post' do
      create
      expect(JSON.parse(response.body)).to eq serialized_new_post
    end

    it 'returns success status' do
      create
      expect(response).to be_successful
    end
  end
end