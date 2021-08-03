require 'rails_helper'

RSpec.describe CustomField, type: :model do
  subject(:custom_field) { create :custom_field }

  describe '#component[=]' do
    it_behaves_like 'stored accessor', :component, -> { FactoryBot.create :component}
  end

  describe '#name[=]' do
    it_behaves_like 'stored accessor', :name, 'test name'
  end

  describe '#value[=]' do
    it_behaves_like 'stored accessor', :value, 'test value'
  end

  describe 'Validation' do
    context 'without #component' do
      before { subject.component = nil }
      it_behaves_like 'invalid', :component
    end

    context 'without #name' do
      before { subject.name = nil }
      it_behaves_like 'invalid', :name
    end

    context 'without #value' do
      before { subject.value = nil }
      it_behaves_like 'invalid', :value
    end

    context 'with duplicating name for the same component' do
      before do
        create :custom_field, component: custom_field.component, name: 'help'
        subject.name = 'help'
      end

      it_behaves_like 'invalid', :name
    end

    context 'with duplicating name across other components' do
      before do
        create :custom_field, name: 'help'
        subject.name = 'help'
      end

      it 'is valid' do
        expect(subject).to be_valid
      end
    end
  end
end
