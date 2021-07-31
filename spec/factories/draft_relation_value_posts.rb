FactoryBot.define do
  factory :draft_relation_value_post do
    # FIXME: relation_value <-> component <-> *post*
    association :relation_value
    association :post
  end
end
