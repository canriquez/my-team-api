FactoryBot.define do
  factory :user do
    email { "MyString" }
    name { "MyString" }
    role { 1 }
    password_digest { "MyString" }
  end
end
