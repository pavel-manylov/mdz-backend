FactoryBot.define do
  factory :string_value do
    sequence(:value) {|i| "Text #{i}" }
  end
end
