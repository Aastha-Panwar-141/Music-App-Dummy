FactoryBot.define do
  factory :song_request do
    price { 20 }
    requested_percent { 15 }
    song_split
    # assocaition {:song_split}, factory: :song_split
    association :requester, factory: :user
    association :receiver, factory: :user
  end
end
