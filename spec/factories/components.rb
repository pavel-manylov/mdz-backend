FactoryBot.define do
  factory :component do
    public { true }
    association :post
    association :value, factory: :boolean_value
  end
end
