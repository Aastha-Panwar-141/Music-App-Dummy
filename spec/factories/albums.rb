FactoryBot.define do
  factory :album do
    sequence(:title) { |n| "Album #{n}" }
    # title { Faker::Music.album }
    user_id {FactoryBot.create(:artist).id}
  end
end
