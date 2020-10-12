FactoryBot.define do
  factory :balcklisted_token do
    jti { "MyString" }
    user { nil }
    exp { "2020-10-12 14:43:21" }
  end
end
