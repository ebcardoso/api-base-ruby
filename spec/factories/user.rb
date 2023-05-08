FactoryBot.define do
  factory :user_001, class: User do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { 'pass@1915' }
  end
end
