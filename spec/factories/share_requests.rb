FactoryBot.define do
  factory :share_request do
    price { 20 }
    requested_percent { 15 }
    split
    association :requester, factory: :user
    association :receiver, factory: :user
  end
end
