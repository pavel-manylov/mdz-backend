require 'rails_helper'

RSpec.describe StringValue, type: :model do
  subject(:string_value){ create :string_value}

  it_behaves_like 'component value' do
    subject(:value_object){ string_value }
  end

  describe '#value[=]' do
    it_behaves_like 'stored accessor', :value, 'test string value'

    context 'with long text values' do
      it_behaves_like 'stored accessor', :value, 'long text value' * 100
    end
  end

  describe '#draft_value[=]' do
    it_behaves_like 'stored accessor', :draft_value, 'test string value'

    context 'with long text values' do
      it_behaves_like 'stored accessor', :draft_value, 'long text value' * 100
    end
  end
end
