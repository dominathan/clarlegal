FactoryGirl.define do

  factory :lawfirm do
    firm_name             "New Test Firm LLC"
    password              "password"
    password_confirmation "password"
  end

  factory :user do
    association           :lawfirm
    first_name             "Jimmy"
    last_name              "McJim"
    email                 "test@example.com"
    password              "password"
    password_confirmation "password"
  end


end
