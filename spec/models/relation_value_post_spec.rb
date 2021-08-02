require 'rails_helper'

RSpec.describe RelationValuePost, type: :model do
  subject(:relation_value_post) { create :relation_value_post }

  describe '#post[=]' do
    it_behaves_like 'stored accessor', :post, -> { FactoryBot.create :post }
  end

  describe '#relation_value[=]' do
    it_behaves_like 'stored accessor', :relation_value, -> { FactoryBot.create :relation_value }
  end

  describe 'Validation' do
    context 'without #post' do
      before { subject.post = nil }
      it_behaves_like 'invalid', :post
    end

    context 'without #relation_value' do
      before { subject.relation_value = nil }
      it_behaves_like 'invalid', :relation_value
    end
  end
end
