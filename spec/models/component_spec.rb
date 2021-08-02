require 'rails_helper'

RSpec.describe Component, type: :model do
  subject(:component) { create :component }

  describe '#public[=]' do
    before do
      expect(component.public).to be true # foolproof check
    end

    it_behaves_like 'stored accessor', :public, false
  end

  example '#public? returns the same value as #public' do
    component.public = true
    expect(component.public).to be true

    component.public = false
    expect(component.public).to be false
  end

  describe '#display_class[=]' do
    it_behaves_like 'stored accessor', :display_class, 'headline'

    it 'resets empty value to nil' do
      component.display_class = '   '
      component.save

      expect(component.display_class).to be_nil
    end
  end

  describe '#order[=]' do
    it_behaves_like 'stored accessor', :order, 25
  end

  describe '#post[=]' do
    it_behaves_like 'stored accessor', :post, -> { FactoryBot.create :post }
  end

  describe '#value[=]' do
    context 'with BooleanValue' do
      it_behaves_like 'stored accessor', :value, -> { FactoryBot.create :boolean_value }
    end
  end

  example '#custom_fields returns all associated CustomField(s)' do
    created_fields = 3.times.map{ create :custom_field, component: component }
    expect(component.custom_fields).to match_array created_fields
  end

  describe '#destroy' do
    it 'destroys associated value' do
      value = component.value
      expect(value).not_to be_nil # foolproof check

      component.destroy!
      expect { value.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'Validation' do
    context 'with empty #public' do
      before { component.public = nil }
      it_behaves_like 'invalid', :public
    end

    context 'without #order' do
      before { component.order = nil }
      it_behaves_like 'invalid', :order
    end

    context 'with negative #order' do
      before { component.order = -5 }
      it_behaves_like 'invalid', :order
    end

    context 'with floating point #order' do
      before { component.order = 5.55 }
      it_behaves_like 'invalid', :order
    end

    context 'without #post' do
      before { component.post = nil }
      it_behaves_like 'invalid', :post
    end

    context 'without #value' do
      before { component.value = nil }
      it_behaves_like 'invalid', :value
    end

    context 'with unsupported value class' do
      before { component.value = create(:post) }
      it_behaves_like 'invalid', :value
    end
  end
end
