FactoryGirl.define do

  factory :lawfirm do
    sequence(:firm_name) { |n| "New Test Firm LLC#{n}" }
    password                   "password"
    password_confirmation      "password"
  end

  factory :user do
    association            :lawfirm
    first_name             "Jimmy"
    last_name              "McJim"
    sequence(:email) { |n| "test#{n}@example.com" }
    password               "password"
    password_confirmation  "password"
    activated              true
    activated_at           Time.zone.now
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

  factory :practicegroup do
    association                  :lawfirm
    sequence(:group_name)  { |n| "practice_group#{n}" }
  end

  factory :case do
    association           :client
    practicegroup_id      1
    sequence(:name) { |n| "Me v. World#{n}" }
    open                  false
    court                 "Jeff Co"
  end

  factory :closeout do
    association                     :case
    total_recovery                  5
    total_gross_fee_received        4
    total_out_of_pocket_expenses    3
    referring_fees_paid             2
    total_fee_received              1
    fee_type                        "Contingency"
    date_fee_received               Date.today
  end

  factory :overhead do
    association                     :lawfirm
    rent                            3000000
    billable_hours_per_lawyer       2000
    number_of_billable_staff        20
    rate_per_hour                   75
  end
end


