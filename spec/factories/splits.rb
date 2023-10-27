FactoryBot.define do
  factory :split do
    association :requester, factory: :user
    association :receiver, factory: :user
    percentage { 100 }
  end
end
