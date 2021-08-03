require 'rails_helper'

RSpec.describe ComponentsController, type: :controller do
  describe 'POST posts/:post_id/component' do
    subject(:create) { post :create, params: params }

    let(:params) do
      {
        post_id: new_component_post_id,
        public: new_component_public,
        display_class: new_component_display_class,
        order: new_component_order,
        custom_fields: new_component_custom_fields,
        type: new_component_type,
        value: new_component_value
      }
    end

    let(:new_component_post_id) { 123 }
    let(:new_component_public) { true }
    let(:new_component_display_class) { 'caption' }
    let(:new_component_order) { 33 }
    let(:new_component_custom_fields) do
      { 'as-preview' => 'no' }
    end
    let(:new_component_type) { 'boolean' }
    let(:new_component_value) { true }

    let(:new_component) { double Component }
    let(:serialized_new_component) do
      {
        'post_id' => new_component_post_id,
        'public' => new_component_public,
        'display_class' => new_component_display_class,
        'order' => new_component_order,
        'custom_fields' => new_component_custom_fields,
        'type' => new_component_type,
        'value' => new_component_value
      }
    end

    before do
      allow(CreateComponent).to receive(:run!).and_return new_component
      allow(ComponentSerializer).to receive(:serialize).with(new_component).and_return serialized_new_component
    end

    it 'creates new component' do
      create

      expect(CreateComponent).to have_received(:run!).with(
        'post_id' => new_component_post_id.to_s,
        'public' => 'true',
        'display_class' => new_component_display_class,
        'order' => new_component_order.to_s,
        'custom_fields' => new_component_custom_fields,
        'type' => new_component_type,
        'value' => 'true'
      )
    end

    it 'returns serialized component' do
      create
      expect(JSON.parse(response.body)).to eq serialized_new_component
    end

    it 'returns success status' do
      create
      expect(response).to be_successful
    end

    include_examples 'controller interaction errors', interaction_class: CreateComponent do
      subject(:perform) { create }
    end
  end

  describe 'GET posts/:post_id/components' do
    subject(:index) { get :index, params: { post_id: post_id } }
    let(:post_id) { 123 }

    let(:components_double) do
      [
        double(Component, post_id: post_id, id: 1),
        double(Component, post_id: post_id, id: 2)
      ]
    end

    let(:serialized_components) do
      [
        { 'post_id' => post_id, 'id' => 1 },
        { 'post_id' => post_id, 'id' => 2 }
      ]
    end

    before do
      allow(IndexComponents).to receive(:run!).and_return components_double
      allow(ComponentSerializer).to receive(:serialize).with(components_double).and_return serialized_components
    end

    it 'returns serialized components' do
      index
      expect(JSON.parse(response.body)).to eq serialized_components
    end

    it 'returns success status' do
      index
      expect(response).to be_successful
    end

    include_examples 'controller interaction errors', interaction_class: IndexComponents do
      subject(:perform) { index }
    end
  end
end