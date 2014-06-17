FactoryGirl.define do
  factory :user do
    name     "Nathan Hall"
    email    "nathan@example.com"
    password "password"
    password_confirmation "password"
  end
end
