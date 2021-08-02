require 'rails_helper'

RSpec.describe Post, type: :model do
  subject(:post) { create :post }

  describe '#components' do
    subject(:components) { post.components }

    let!(:created_components) { 3.times.map { create :component, post: post } }

    it 'returns all associated components' do
      expect(components).to match_array created_components
    end
  end

  describe '#name[=]' do
    it_behaves_like 'stored accessor', :name, 'Тестовое название'
  end

  describe '#seo_url[=]' do
    it_behaves_like 'stored accessor', :seo_url, 'god-loves-everyone'
  end

  describe '#destroy' do
    it 'destroys all associated components' do
      component = create :component, post: post
      post.destroy!

      expect(Component.find_by_id component.id).to be_nil
    end
  end

  describe 'Validation' do
    context 'without #name' do
      before { subject.name = ' ' }
      it_behaves_like 'invalid', :name
    end
  end

end
