FactoryBot.define do
  factory :album do
    title { Faker::Music.album }
    user_id {FactoryBot.create(:artist).id}
  end
end
