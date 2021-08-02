require 'rails_helper'

RSpec.describe RelationValue, type: :model do
  subject(:relation_value) { create :relation_value }

  it_behaves_like 'component value' do
    subject(:value_object) { relation_value }
  end

  describe '#value[=]' do
    it 'updates associated posts list' do
      posts = 3.times.map{ create :post }
      relation_value.value = posts
      relation_value.save!

      reloaded = RelationValue.find relation_value.id

      expect(reloaded.posts).to match_array posts
    end

    it 'does not recreate RelationValuePost(s)' do
      relation_value.value = 3.times.map{ create :post }
      relation_value.save!

      initial_ids = relation_value.relation_value_posts.pluck(:id)
      expect(initial_ids.size).to eql 3 # foolproof check

      relation_value.value = relation_value.value
      relation_value.save!

      expect(relation_value.relation_value_posts.pluck(:id)).to match_array initial_ids
    end

    it 'defaults to nil value' do
      expect(described_class.new.value).to be_nil
    end

    it 'allows nil value' do
      relation_value.value = nil
      relation_value.save!

      reloaded = described_class.find relation_value.id
      expect(reloaded.posts).to be_empty
      expect(reloaded.value).to be_nil
    end
  end

  example '#posts returns all associated Post(s)' do
    posts = 3.times.map do
      post = create :post
      create :relation_value_post, post: post, relation_value: relation_value
      post
    end

    expect(relation_value.posts).to match_array posts
  end
end
