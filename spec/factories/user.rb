FactoryBot.define do
  factory :user_001, class: User do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { 'pass@1915' }
  
    token_password_recovery { SecureRandom.hex(3) }
    token_password_recovery_deadline { ActiveSupport::TimeZone[-3].now+10.minutes }
  end
end
