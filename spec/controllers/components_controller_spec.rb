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

    it 'searches for related components' do
      index

      expect(IndexComponents).to have_received(:run!).with(
        post_id: post_id.to_s
      )
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

  describe 'PUT posts/:post_id/components/:id' do
    subject(:update) { put :update, params: params }
    let(:params) do
      {
        post_id: post_id,
        id: component_id,
        public: component_public,
        display_class: component_display_class,
        order: component_order,
        custom_fields: component_custom_fields,
        type: component_type,
        value: component_value
      }
    end

    let(:post_id) { 123 }
    let(:component_id) { 222 }
    let(:component_public) { true }
    let(:component_display_class) { 'caption' }
    let(:component_order) { 33 }
    let(:component_custom_fields) do
      { 'as-preview' => 'no' }
    end
    let(:component_type) { 'relation' }
    let(:component_value) { [{ 'post_id' => 123 }] }

    let(:serialized_component) do
      {
        'id' => component_id,
        'display_class' => component_display_class
      }
    end

    let(:component_double) { double Component, id: component_id }

    before do
      allow(UpdateComponent).to receive(:run!).and_return component_double
      allow(ComponentSerializer).to receive(:serialize).with(component_double).and_return serialized_component
    end

    it 'updates component' do
      update

      expect(UpdateComponent).to have_received(:run!).with(
        'post_id' => post_id.to_s,
        'component_id' => component_id.to_s,
        'public' => 'true',
        'display_class' => component_display_class,
        'order' => component_order.to_s,
        'custom_fields' => component_custom_fields,
        'type' => component_type,
        'value' => [{ 'post_id' => "123" }]
      )
    end

    it 'returns serialized component' do
      update
      expect(JSON.parse(response.body)).to eq serialized_component
    end

    it 'returns success status' do
      update
      expect(response).to be_successful
    end

    include_examples 'controller interaction errors', interaction_class: UpdateComponent do
      subject(:perform) { update }
    end

  end

  describe 'DELETE posts/:post_id/components/:id' do
    subject(:destroy) { delete :destroy, params: params }
    let(:params) do
      {
        post_id: post_id,
        id: component_id
      }
    end

    let(:post_id) { 123 }
    let(:component_id) { 222 }

    before do
      allow(DeleteComponent).to receive(:run!).and_return true
    end

    it 'deletes component' do
      destroy

      expect(DeleteComponent).to have_received(:run!).with component_id: component_id.to_s
    end

    it 'returns success status' do
      destroy
      expect(response).to be_successful
    end

    include_examples 'controller interaction errors', interaction_class: DeleteComponent do
      subject(:perform) { destroy }
    end

  end

  describe 'GET posts/:post_id/components/:id' do
    subject(:show) { get :show, params: { post_id: post_id, id: component_id } }
    let(:post_id) { 123 }

    let(:component_id) { 111 }
    let(:component_double) { double Component, post_id: post_id, id: component_id }

    let(:serialized_component) do
      { 'post_id' => post_id, 'id' => component_id }
    end

    before do
      allow(GetComponent).to receive(:run!).and_return component_double
      allow(ComponentSerializer).to receive(:serialize).with(component_double).and_return serialized_component
    end

    it 'searches for referenced component' do
      show

      expect(GetComponent).to have_received(:run!).with(
        component_id: component_id.to_s
      )
    end

    it 'returns serialized component' do
      show
      expect(JSON.parse(response.body)).to eq serialized_component
    end

    it 'returns success status' do
      show
      expect(response).to be_successful
    end

    include_examples 'controller interaction errors', interaction_class: GetComponent do
      subject(:perform) { show }
    end
  end
end