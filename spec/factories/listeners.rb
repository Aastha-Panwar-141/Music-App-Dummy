FactoryBot.define do
  factory :listener do
    username      { Faker::Name.name }
    email         { Faker::Internet.email}
    password      { Faker::Internet.password(min_length: 8)}
    user_type     {'Listener'}
  end
end
