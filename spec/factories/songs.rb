FactoryBot.define do
  factory :song do
    sequence(:title) { |n| "Song #{n}" }
    # title { Faker::Music::RockBand.unique.name }
    genre { Faker::Music.genre }
    status { ['public', 'private'].sample }
    album
    user_id { FactoryBot.create(:artist).id }
    # album_id { FactoryBot.create(:album).id }
    # association :artist, factory: :user, user_type: 'Artist'
    # association :album  # explicit assosiation
    # album # implicit assosiation

    trait :with_file do
      after :build do |song|
        song.file.attach(io: File.open(Rails.root.join('spec', 'support', 'test.mp3')), filename: 'test.mp3', content_type: 'audio/mpeg')
      end
    end
  end

end
