FactoryBot.define do
  factory :playlist do
    title { "Playlist 1" }
    user_id { FactoryBot.create(:listener).id }
  end
end
