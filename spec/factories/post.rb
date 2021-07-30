FactoryBot.define do
  factory :post do
    sequence(:name) { |i| "Пост ##{i}" }
    draft{ false }
  end
end