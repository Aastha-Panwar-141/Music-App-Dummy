require 'faker'

FactoryBot.define do
  factory :user do
    # byebug
    username      { Faker::Name.unique.name }
    email         { Faker::Internet.email}
    password      { Faker::Internet.password(min_length: 8)}
    user_type     {['Artist','Listener'].sample}
    
    # username { 'Aastha' }
    # password  { 'admin@123' }
    # email { 'aastha@gmail.com' }
    # user_type { 'Artist' }
  end
end
