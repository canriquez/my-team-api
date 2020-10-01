FactoryBot.define do
  factory :jobpost do
    name { Faker::IndustrySegments.sub_sector }
    enabled { true }
    author { 1 }
    image { 'https://image.org'}
  end
end
