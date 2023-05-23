FactoryBot.define do
  factory :user_001, class: User do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { 'pass@1915' }
  
    token_password_recovery { '12c45f'}
    token_password_recovery_deadline { DateTime.now+10.minutes  }
  end
end
