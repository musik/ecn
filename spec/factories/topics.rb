# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :topic do
    name "MyString"
    slug "MyString"
    products_count 1
  end
end
