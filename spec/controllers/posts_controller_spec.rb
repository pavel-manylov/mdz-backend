require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  describe "POST /posts" do
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

    include_examples 'controller interaction errors', interaction_class: CreatePost do
      subject(:perform){ create }
    end
  end

  describe "GET /posts/:id" do
    subject(:get_request) { get :show, params: { id: post_id } }
    let(:post_id) { 123 }

    let(:post_double) { double Post, id: post_id }
    let(:serialized_post) do
      {
        'id' => post_id
      }
    end

    before do
      allow(GetPost).to receive(:run!).and_return post_double
      allow(PostSerializer).to receive(:serialize).with(post_double).and_return serialized_post
    end

    it 'returns serialized post' do
      get_request
      expect(JSON.parse(response.body)).to eq serialized_post
    end

    it 'returns success status' do
      get_request
      expect(response).to be_successful
    end

    include_examples 'controller interaction errors', interaction_class: GetPost do
      subject(:perform) { get_request }
    end
  end

  describe 'PUT posts/:post_id' do
    subject(:update) { put :update, params: params }
    let(:params) do
      { id: post_id, name: post_name, seo_url: post_seo_url }
    end

    let(:post_name) { 'updated_post_name' }
    let(:post_seo_url) { 'updated_post_seo_url' }

    let(:post_id) { 123 }

    let(:serialized_post) do
      {
        'id' => post_id,
        'name' => post_name
      }
    end

    let(:post_double) { double Post, id: post_id }

    before do
      allow(UpdatePost).to receive(:run!).and_return post_double
      allow(PostSerializer).to receive(:serialize).with(post_double).and_return serialized_post
    end

    it 'updates post' do
      update

      expect(UpdatePost).to have_received(:run!).with(
        'post_id' => post_id.to_s,
        'seo_url' => post_seo_url,
        'name' => post_name
      )
    end

    it 'returns serialized post' do
      update
      expect(JSON.parse(response.body)).to eq serialized_post
    end

    it 'returns success status' do
      update
      expect(response).to be_successful
    end

    include_examples 'controller interaction errors', interaction_class: UpdatePost do
      subject(:perform) { update }
    end

  end
end