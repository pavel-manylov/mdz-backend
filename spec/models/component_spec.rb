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
    subject.public = true
    expect(subject.public).to be true

    subject.public = false
    expect(subject.public).to be false
  end

  describe '#display_class[=]' do
    it_behaves_like 'stored accessor', :display_class, 'headline'

    it 'resets empty value to nil' do
      subject.display_class = '   '
      subject.save

      expect(subject.display_class).to be_nil
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

  describe '#destroy' do
    it 'destroys associated value' do
      value = subject.value
      expect(value).not_to be_nil # foolproof check

      subject.destroy!
      expect { value.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'Validation' do
    context 'with empty #public' do
      before { subject.public = nil }
      it_behaves_like 'invalid', :public
    end

    context 'without #order' do
      before { subject.order = nil }
      it_behaves_like 'invalid', :order
    end

    context 'with negative #order' do
      before { subject.order = -5 }
      it_behaves_like 'invalid', :order
    end

    context 'with floating point #order' do
      before { subject.order = 5.55 }
      it_behaves_like 'invalid', :order
    end

    context 'without #post' do
      before { subject.post = nil }
      it_behaves_like 'invalid', :post
    end

    context 'without #value' do
      before { subject.value = nil }
      it_behaves_like 'invalid', :value
    end

    context 'with unsupported value class' do
      before { subject.value = create(:post) }
      it_behaves_like 'invalid', :value
    end
  end
end
