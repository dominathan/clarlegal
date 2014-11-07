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
    activated             true
    activated_at          Time.zone.now
  end

  factory :client do
    association           :user
    first_name            "Jo"
    last_name             "Bill"
    email                 "jo@bill.com"
    street_address        "222 Biilly Drive"
    city                  "Aust"
    state                 "AL"
  end


end
