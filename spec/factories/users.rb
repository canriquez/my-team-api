require 'faker'

FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    name { Faker::Name.name }
    password { '12345' }
    avatar { Faker::Internet.url }

    factory :admin_user do
      role { :admin }
    end

    factory :user_user do
      role { :user }
    end
  end
end
