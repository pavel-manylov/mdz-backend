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

    context 'with interaction validation errors' do
      before do
        error = ActiveInteraction::InvalidInteractionError.new
        error.interaction = interaction_with_errors
        allow(CreatePost).to receive(:run!).and_raise(error)
      end

      let(:interaction_with_errors) do
        double ActiveInteraction::Base, errors: double(to_a: readable_errors)
      end

      let(:readable_errors) { ['Name is required'] }

      before{ create }

      it 'returns status code 422' do
        expect(response.status).to eq 422
      end

      example 'body includes all errors' do
        expect(JSON.parse(response.body)).to eq({ 'errors' => readable_errors})
      end
    end

    context 'with interaction exception' do
      before do
        allow(CreatePost).to receive(:run!).and_raise(ActiveInteraction::Error)
      end

      before{ create }

      it 'returns status code 500' do
        expect(response.status).to eq 500
      end

      example 'body includes some error message' do
        expect(JSON.parse(response.body)['errors']).to be_present
      end
    end

    context 'with other exception' do
      before do
        allow(CreatePost).to receive(:run!).and_raise(StandardError)
      end

      before{ create }

      it 'returns status code 500' do
        expect(response.status).to eq 500
      end

      example 'body includes some error message' do
        expect(JSON.parse(response.body)['errors']).to be_present
      end
    end
  end
end