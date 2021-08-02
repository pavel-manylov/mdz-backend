FactoryBot.define do
  factory :post do
    sequence(:name) { |i| "Пост ##{i}" }
  end
end