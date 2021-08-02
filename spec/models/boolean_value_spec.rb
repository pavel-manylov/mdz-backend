require 'rails_helper'

RSpec.describe BooleanValue, type: :model do
  subject(:boolean_value) { create :boolean_value }

  it_behaves_like 'component value' do
    subject(:value_object){ boolean_value }
  end

  describe '#value[=]' do
    before do
      expect(subject.value).to be true # foolproof check
    end

    it_behaves_like 'stored accessor', :value, false
  end

end
