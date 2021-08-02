FactoryBot.define do
  factory :custom_field do
    association :component
    sequence(:name) { |i| "custom field name #{i}" }
    sequence(:value) { |i| "custom field value #{i}" }
  end
end
