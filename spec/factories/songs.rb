FactoryBot.define do
  factory :song do
    title { Faker::Music::RockBand.name }
    genre { Faker::Music.genre }
    status { ['public', 'private'].sample }
    association :artist, factory: :user, user_type: 'Artist'
    association :album

    trait :with_file do
      after :build do |song|
        song.file.attach(io: File.open(Rails.root.join('spec', 'support', 'test.mp3')), filename: 'test.mp3', content_type: 'audio/mpeg')
      end
    end
  end

end
