FactoryBot.define do
  factory :playlist do
    sequence(:title) { |n| "Playlist #{n}"}
    # title { "Playlist 2" }
    user_id { FactoryBot.create(:listener).id }
  end
end
