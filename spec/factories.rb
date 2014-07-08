FactoryGirl.define do

  factory :lawfirm do
    firm_name             "New Test Firm LLC"
    password              "password"
    password_confirmation "password"
  end

  factory :user do
    association           :lawfirm
    name                  "Jimmy McJim"
    email                 "test@example.com"
    password              "password"
    password_confirmation "password"
  end

  factory :practicegroup do
    association           :lawfirm
    group_name            "Commercial Litigation"
  end

  factory :client do
    association           :user
    client_name           "Test Client"
    client_email          "testclient@test.com"
  end

  factory :case do
    association           :client
    association           :lawfirm
    name                  "Me V World"
  end

end
