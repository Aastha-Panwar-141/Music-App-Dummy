FactoryBot.define do
  factory :artist do
    username      { Faker::Name.name }
    email         { Faker::Internet.email}
    password      { Faker::Internet.password(min_length: 8)}
    user_type     {'Artist'}
  end
end
